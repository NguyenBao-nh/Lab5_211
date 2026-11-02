using Microsoft.AspNetCore.Mvc;
using Lab5_211.Models;

namespace Lab5_211.ViewComponents
{
    public class MajorViewComponent : ViewComponent
    {
        private readonly StudentManagementContext db;
        private List<Major> majors;

        public MajorViewComponent(StudentManagementContext context)
        {
            db = context;
            majors = db.Majors.ToList();
        }

        public async Task<IViewComponentResult> InvokeAsync()
        {
            return View("RenderMajor", majors);
        }
    }
}