import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import 'bootstrap/dist/css/bootstrap.min.css'
import { AuthProvider, useAuth } from './contexts/AuthContext'
import ProtectedRoute from './components/auth/ProtectedRoute'
import AppLayout from './layouts/AppLayout'
import Dashboard from './pages/Dashboard'
import Analytics from './pages/Analytics'
import Teams from './pages/Teams'
import ProfileOverview from './pages/ProfileOverview'
import Login from './pages/Login'
import SignUp from './pages/SignUp'
import ForgotPassword from './pages/ForgotPassword'
import Report from "./pages/Report"
import Setting from "./pages/Setting"
import Timeline from "./pages/Timeline"
import PricingPage from "./pages/PricingPage"
import Charts from "./pages/Charts"
import Notification from "./pages/Notification"
import Chat from "./pages/Chat"
import NewUser from "./pages/NewUser"
import Billing from "./pages/Billing"
import NewProject from "./pages/NewProject"
import AllProjects from "./pages/AllProjects"
import Invoice from "./pages/Invoice"
import Kanban from "./pages/Kanban"
import Wizard from "./pages/Wizard"
import DataTables from "./pages/DataTables"
import Calendar from "./pages/Calendar"
import NewProduct from "./pages/NewProduct"
import EditProduct from "./pages/EditProduct"
import ProductList from "./pages/ProductList"
import LanguageList from "./pages/LanguageList"
import CourseList from "./pages/CourseList"
import LessonList from "./pages/LessonList"
import ExerciseList from "./pages/ExerciseList"
import ProgressPage from "./pages/ProgressPage"
import PaymentTransactionsPage from "./pages/data/PaymentTransactionsPage"
import StudyLogsPage from "./pages/data/StudyLogsPage"
import SubscriptionsDataPage from "./pages/data/SubscriptionsPage"
import LearningPathList from "./pages/LearningPathList"
import TopicList from "./pages/TopicList"
import OnboardingPage from "./pages/OnboardingPage"
import SubscriptionPlansAdminPage from "./pages/SubscriptionPlansAdminPage"


import './styles/layout.css'
import './styles/dashboard.css'
import './styles/analytics.css'
import './styles/auth.css'
import './styles/Timeline.css'
import './styles/profile-overview.css'
import './styles/pricingpage.css'
import './styles/Charts.css'
import './styles/Notification.css'
import './styles/Chat.css'
import './styles/Billing.css'
import './styles/NewUser.css'
import './styles/NewProject.css'
import './styles/allprojects.css'
import './styles/invoice.css'
import './styles/Kanban.css'
import './styles/wizard.css'
import './styles/DataTables.css'
import './styles/calendar.css'
import './styles/newproduct.css'
import './styles/editproduct.css'
import './styles/productlist.css'
import './styles/languagelist.css'
import './styles/courselist.css'
import './styles/lessonlist.css'
import './styles/exerciselist.css'
import './styles/progresspage.css'
import './styles/dataTablesPages.css'
import './styles/learningpathlist.css'
import './styles/topiclist.css'
import './styles/onboarding.css'
import './styles/subscriptionplansadmin.css'




function DashboardRoute() {
  return (
    <ProtectedRoute>
      <AppLayout>
        <Dashboard />
      </AppLayout>
    </ProtectedRoute>
  )
}

function AnalyticsRoute() {
  return (
    <ProtectedRoute>
      <AppLayout>
        <Analytics />
      </AppLayout>
    </ProtectedRoute>
  )
}

function TeamsRoute() {
  return (
    <ProtectedRoute>
      <AppLayout>
        <Teams />
      </AppLayout>
    </ProtectedRoute>
  )
}

function ProfileOverviewRoute() {
  return (
    <ProtectedRoute>
      <AppLayout>
        <ProfileOverview />
      </AppLayout>
    </ProtectedRoute>
  )
}
function ReportRoute() {
  return (
    <ProtectedRoute>
      <AppLayout>
        <Report />
      </AppLayout>
    </ProtectedRoute>
  )
}
function SettingRoute() {
  return (
    <ProtectedRoute>
      <AppLayout>
        <Setting />
      </AppLayout>
    </ProtectedRoute>
  )
}
function TimelineRoute() {
  return (
    <ProtectedRoute>
      <AppLayout>
        <Timeline/>
      </AppLayout>
    </ProtectedRoute>
  )
}
function PricingPageRoute() {
  return (
    <ProtectedRoute>
      <AppLayout>
        <PricingPage/>
      </AppLayout>
    </ProtectedRoute>
  )
}
function ChartsRoute() {
  return (
    <ProtectedRoute>
      <AppLayout>
        <Charts/>
      </AppLayout>
    </ProtectedRoute>
  )
}
function NotificationRoute() {
  return (
    <ProtectedRoute>
      <AppLayout>
        <Notification/>
      </AppLayout>
    </ProtectedRoute>
  )
}
function ChatRoute() {
  return (
    <ProtectedRoute>
      <AppLayout>
        <Chat/>
      </AppLayout>
    </ProtectedRoute>
  )
}
function NewUserRoute() {
  return (
    <ProtectedRoute>
      <AppLayout>
        <NewUser/>
      </AppLayout>
    </ProtectedRoute>
  )
}
function BillingRoute() {
  return (
    <ProtectedRoute>
      <AppLayout>
        <Billing/>
      </AppLayout>
    </ProtectedRoute>
  )
}
function NewProjectRoute() {
  return (
    <ProtectedRoute>
      <AppLayout>
        <NewProject/>
      </AppLayout>
    </ProtectedRoute>
  )
}
function AllProjectsRoute() {
  return (
    <ProtectedRoute>
      <AppLayout>
        <AllProjects/>
      </AppLayout>
    </ProtectedRoute>
  )
}
function InvoiceRoute() {
  return (
    <ProtectedRoute>
      <AppLayout>
        <Invoice/>
      </AppLayout>
    </ProtectedRoute>
  )
}
function KanbanRoute() {
  return (
    <ProtectedRoute>
      <AppLayout>
        <Kanban/>
      </AppLayout>
    </ProtectedRoute>
  )
}
function WizardRoute() {
  return (
    <ProtectedRoute>
      <AppLayout>
        <Wizard/>
      </AppLayout>
    </ProtectedRoute>
  )
}
function DataTablesRoute() {
  return (
    <ProtectedRoute>
      <AppLayout>
        <DataTables/>
      </AppLayout>
    </ProtectedRoute>
  )
}
function CalendarRoute() {
  return (
    <ProtectedRoute>
      <AppLayout>
        <Calendar/>
      </AppLayout>
    </ProtectedRoute>
  )
}
function NewProductRoute() {
  return (
    <ProtectedRoute>
      <AppLayout>
        <NewProduct/>
      </AppLayout>
    </ProtectedRoute>
  )
}
function EditProductRoute() {
  return (
    <ProtectedRoute>
      <AppLayout>
        <EditProduct/>
      </AppLayout>
    </ProtectedRoute>
  )
}
function ProductListRoute() {
  return (
    <ProtectedRoute>
      <AppLayout>
        <ProductList />
      </AppLayout>
    </ProtectedRoute>
  )
}
function LanguageListRoute() {
  return (
    <ProtectedRoute>
      <AppLayout>
        <LanguageList />
      </AppLayout>
    </ProtectedRoute>
  )
}
function CourseListRoute() {
  return (
    <ProtectedRoute>
      <AppLayout>
        <CourseList />
      </AppLayout>
    </ProtectedRoute>
  )
}
function LessonListRoute() {
  return (
    <ProtectedRoute>
      <AppLayout>
        <LessonList />
      </AppLayout>
    </ProtectedRoute>
  )
}
function ExerciseListRoute() {
  return (
    <ProtectedRoute>
      <AppLayout>
        <ExerciseList />
      </AppLayout>
    </ProtectedRoute>
  )
}
function ProgressPageRoute() {
  return (
    <ProtectedRoute>
      <AppLayout>
        <ProgressPage />
      </AppLayout>
    </ProtectedRoute>
  )
}

function PaymentTransactionsRoute() {
  return (
    <ProtectedRoute>
      <AppLayout>
        <PaymentTransactionsPage />
      </AppLayout>
    </ProtectedRoute>
  )
}

function StudyLogsRoute() {
  return (
    <ProtectedRoute>
      <AppLayout>
        <StudyLogsPage />
      </AppLayout>
    </ProtectedRoute>
  )
}

function SubscriptionsDataRoute() {
  return (
    <ProtectedRoute>
      <AppLayout>
        <SubscriptionsDataPage />
      </AppLayout>
    </ProtectedRoute>
  )
}

function LearningPathListRoute() {
  return (
    <ProtectedRoute>
      <AppLayout>
        <LearningPathList />
      </AppLayout>
    </ProtectedRoute>
  )
}

function TopicListRoute() {
  return (
    <ProtectedRoute>
      <AppLayout>
        <TopicList />
      </AppLayout>
    </ProtectedRoute>
  )
}

function OnboardingPageRoute() {
  return (
    <ProtectedRoute>
      <AppLayout>
        <OnboardingPage />
      </AppLayout>
    </ProtectedRoute>
  )
}

function SubscriptionPlansAdminRoute() {
  return (
    <ProtectedRoute>
      <AppLayout>
        <SubscriptionPlansAdminPage />
      </AppLayout>
    </ProtectedRoute>
  )
}

function LoginRoute() {
  const { isAuthenticated } = useAuth()
  if (isAuthenticated) return <Navigate to="/" replace />
  return <Login />
}

function SignUpRoute() {
  const { isAuthenticated } = useAuth()
  if (isAuthenticated) return <Navigate to="/" replace />
  return <SignUp />
}

function App() {
  return (
    <BrowserRouter>
      <AuthProvider>
        <Routes>
          <Route path="/" element={<DashboardRoute />} />
          <Route path="/analytics" element={<AnalyticsRoute />} />
          <Route path="/teams" element={<TeamsRoute />} />
          <Route path="/profile-overview" element={<ProfileOverviewRoute />} />
          <Route path="/login" element={<LoginRoute />} />
          <Route path="/signup" element={<SignUpRoute />} />
          <Route path="/forgot-password" element={<ForgotPassword />} />
          <Route path="/report" element={<ReportRoute />} />
          <Route path="/setting" element={<SettingRoute />} />
          <Route path="/timeline" element={<TimelineRoute />} />
          <Route path="/pricing-page" element={<PricingPageRoute />} />
          <Route path="/charts" element={<ChartsRoute />} />
          <Route path="/notification" element={<NotificationRoute />} />
          <Route path="/chat" element={<ChatRoute />} />
          <Route path="/new-user" element={<NewUserRoute />} />
          <Route path="/billing" element={<BillingRoute />} />
          <Route path="/new-project" element={<NewProjectRoute />} />
          <Route path="/allprojects" element={<AllProjectsRoute />} />
          <Route path="/invoice" element={<InvoiceRoute />} />
          <Route path="/kanban" element={<KanbanRoute />} />
          <Route path="/wizard" element={<WizardRoute />} />
          <Route path="/datatables" element={<DataTablesRoute />} />
          <Route path="/calendar" element={<CalendarRoute />} />
          <Route path="/new-product" element={<NewProductRoute />} />
           <Route path="/edit-product" element={<EditProductRoute />} />
          <Route path="/product-list" element={<ProductListRoute />} />
          <Route path="/languages" element={<LanguageListRoute />} />
          <Route path="/courses" element={<CourseListRoute />} />
          <Route path="/lessons" element={<LessonListRoute />} />
          <Route path="/exercises" element={<ExerciseListRoute />} />
          <Route path="/progress" element={<ProgressPageRoute />} />
          <Route path="/learning-paths" element={<LearningPathListRoute />} />
          <Route path="/topics" element={<TopicListRoute />} />
          <Route path="/onboarding" element={<OnboardingPageRoute />} />
          <Route path="/admin/subscription-plans" element={<SubscriptionPlansAdminRoute />} />
          <Route path="/data/payment-transactions" element={<PaymentTransactionsRoute />} />
          <Route path="/data/study-logs" element={<StudyLogsRoute />} />
          <Route path="/data/subscriptions" element={<SubscriptionsDataRoute />} />

          <Route path="*" element={<Navigate to="/" replace />} />
        </Routes>
      </AuthProvider>
    </BrowserRouter>
  )
}

export default App
