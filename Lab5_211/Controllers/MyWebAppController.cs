using Lab5_211.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;

namespace Lab5_211.Controllers
{
    public class MyWebAppController : Controller
    {
        private int pageSize = 3;
        private StudentManagementContext db;

        public MyWebAppController(StudentManagementContext db)
        {
            this.db = db;
        }

        // Lọc theo ngành + từ khóa, tính số trang và lấy dữ liệu của trang được chọn
        private List<Learner> GetPage(int? mid, string? keyword, int? pageIndex)
        {
            var learners = (IQueryable<Learner>)db.Learners;

            if (mid != null)
            {
                learners = learners.Where(l => l.MajorId == mid);
            }

            if (!string.IsNullOrWhiteSpace(keyword))
            {
                keyword = keyword.Trim();
                learners = learners.Where(l => l.FirstMidName.Contains(keyword)
                                            || l.LastName.Contains(keyword));
            }

            // Tính số trang (ít nhất 1 trang để thanh phân trang không bị trống)
            int totalItems = learners.Count();
            int pageNum = Math.Max(1, (int)Math.Ceiling(totalItems / (float)pageSize));

            // Giới hạn trang hiện tại trong khoảng [1, pageNum]
            int page = pageIndex ?? 1;
            if (page < 1) page = 1;
            if (page > pageNum) page = pageNum;

            ViewBag.mid = mid;
            ViewBag.keyword = keyword;
            ViewBag.pageNum = pageNum;
            ViewBag.pageIndex = page;
            ViewBag.totalItems = totalItems;

            // Phải sắp xếp trước khi Skip/Take thì thứ tự giữa các trang mới ổn định
            return learners.OrderBy(l => l.LearnerId)
                           .Skip(pageSize * (page - 1))
                           .Take(pageSize)
                           .Include(l => l.Major)
                           .ToList();
        }

        public IActionResult Index(int? mid, string? keyword, int? pageIndex)
        {
            return View(GetPage(mid, keyword, pageIndex));
        }

        [HttpGet]
        public IActionResult Create()
        {
            ViewBag.MajorId = new SelectList(db.Majors, "MajorId", "MajorName");
            return View();
        }
        [HttpPost]
        public IActionResult Create([Bind("FirstMidName,LastName,MajorId,EnrollmentDate")] Learner learner)
        {
            if (ModelState.IsValid)
            {
                db.Learners.Add(learner);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.MajorId = new SelectList(db.Majors, "MajorId", "MajorName", learner.MajorId);
            return View(learner);
        }
        [HttpGet]
        public IActionResult Edit(int id)
        {
            if (id == null || db.Learners == null)
            {
                return NotFound();
            }
            var learner = db.Learners.Find(id);
            if (learner == null)
            {
                return NotFound();
            }
            ViewBag.MajorId = new SelectList(db.Majors, "MajorId", "MajorName", learner.MajorId);
            return View(learner);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Edit(int id, [Bind("LearnerId,FirstMidName,LastName,MajorId,EnrollmentDate")] Learner learner)
        {
            if (id != learner.LearnerId)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    db.Update(learner);
                    db.SaveChanges();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!db.Learners.Any(e => e.LearnerId == learner.LearnerId))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }

            ViewBag.MajorId = new SelectList(db.Majors, "MajorId", "MajorName", learner.MajorId);
            return View(learner);
        }
        public IActionResult LearnerByMajorID(int mid)
        {
            var learners = db.Learners.Where(l => l.MajorId == mid).Include(m => m.Major).ToList();
            return PartialView("LearnerTable", learners);
        }

        // Gọi bằng AJAX: trả về bảng + thanh phân trang của trang được chọn
        public IActionResult LearnerFilter(int? mid, string? keyword, int? pageIndex)
        {
            return PartialView("LearnerTable", GetPage(mid, keyword, pageIndex));
        }
    }
}
