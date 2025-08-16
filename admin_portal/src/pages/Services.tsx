import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { 
  Dialog, 
  DialogContent, 
  DialogDescription, 
  DialogHeader, 
  DialogTitle, 
  DialogTrigger 
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Switch } from "@/components/ui/switch";
import { 
  Plus, 
  Calendar, 
  Users, 
  Clock, 
  FileText, 
  Settings,
  Eye
} from "lucide-react";

interface Service {
  id: number;
  title: string;
  description: string;
  isActive: boolean;
  totalBookings: number;
  pendingBookings: number;
  requiredDocs: string[];
  estimatedTime: string;
}

const Services = () => {
  const navigate = useNavigate();
  const [services, setServices] = useState<Service[]>([
    {
      id: 1,
      title: "Birth Certificate",
      description: "Official birth certificate issuance and verification",
      isActive: true,
      totalBookings: 45,
      pendingBookings: 8,
      requiredDocs: ["Hospital Birth Record", "Parents' ID Copies"],
      estimatedTime: "30 mins"
    },
    {
      id: 2,
      title: "Marriage Certificate",
      description: "Marriage certificate registration and issuance",
      isActive: true,
      totalBookings: 23,
      pendingBookings: 3,
      requiredDocs: ["Birth Certificates", "ID Copies", "Marriage Photos"],
      estimatedTime: "45 mins"
    },
    {
      id: 3,
      title: "Death Certificate",
      description: "Death certificate issuance for legal purposes",
      isActive: true,
      totalBookings: 12,
      pendingBookings: 2,
      requiredDocs: ["Medical Report", "ID Copy", "Witness Statement"],
      estimatedTime: "25 mins"
    },
    {
      id: 4,
      title: "Name Change Certificate",
      description: "Legal name change documentation and processing",
      isActive: false,
      totalBookings: 8,
      pendingBookings: 1,
      requiredDocs: ["Current ID", "Gazette Notification", "Affidavit"],
      estimatedTime: "60 mins"
    }
  ]);

  const [newService, setNewService] = useState({
    title: "",
    description: "",
    estimatedTime: "",
    requiredDocs: ""
  });

  const [isAddDialogOpen, setIsAddDialogOpen] = useState(false);

  const handleAddService = () => {
    const service: Service = {
      id: services.length + 1,
      title: newService.title,
      description: newService.description,
      isActive: true,
      totalBookings: 0,
      pendingBookings: 0,
      requiredDocs: newService.requiredDocs.split(",").map(doc => doc.trim()),
      estimatedTime: newService.estimatedTime
    };

    setServices([...services, service]);
    setNewService({ title: "", description: "", estimatedTime: "", requiredDocs: "" });
    setIsAddDialogOpen(false);
  };

  const toggleServiceStatus = (id: number) => {
    setServices(services.map(service => 
      service.id === id ? { ...service, isActive: !service.isActive } : service
    ));
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Services Management</h1>
          <p className="text-gray-600 mt-1">Manage department services and time slots</p>
        </div>
        
        <Dialog open={isAddDialogOpen} onOpenChange={setIsAddDialogOpen}>
          <DialogTrigger asChild>
            <Button className="bg-blue-600 hover:bg-blue-700">
              <Plus className="w-4 h-4 mr-2" />
              Add New Service
            </Button>
          </DialogTrigger>
          <DialogContent className="sm:max-w-md">
            <DialogHeader>
              <DialogTitle>Add New Service</DialogTitle>
              <DialogDescription>
                Create a new service that citizens can book appointments for.
              </DialogDescription>
            </DialogHeader>
            <div className="space-y-4">
              <div>
                <Label htmlFor="title">Service Title</Label>
                <Input
                  id="title"
                  value={newService.title}
                  onChange={(e) => setNewService({...newService, title: e.target.value})}
                  placeholder="e.g., Birth Certificate"
                />
              </div>
              <div>
                <Label htmlFor="description">Description</Label>
                <Textarea
                  id="description"
                  value={newService.description}
                  onChange={(e) => setNewService({...newService, description: e.target.value})}
                  placeholder="Describe the service..."
                />
              </div>
              <div>
                <Label htmlFor="time">Estimated Time</Label>
                <Input
                  id="time"
                  value={newService.estimatedTime}
                  onChange={(e) => setNewService({...newService, estimatedTime: e.target.value})}
                  placeholder="e.g., 30 mins"
                />
              </div>
              <div>
                <Label htmlFor="docs">Required Documents (comma separated)</Label>
                <Textarea
                  id="docs"
                  value={newService.requiredDocs}
                  onChange={(e) => setNewService({...newService, requiredDocs: e.target.value})}
                  placeholder="e.g., ID Copy, Birth Certificate, Photos"
                />
              </div>
              <Button onClick={handleAddService} className="w-full">
                Add Service
              </Button>
            </div>
          </DialogContent>
        </Dialog>
      </div>

      {/* Services Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {services.map((service) => (
          <Card key={service.id} className="hover:shadow-md transition-shadow">
            <CardHeader className="pb-3">
              <div className="flex items-center justify-between">
                <CardTitle className="text-lg">{service.title}</CardTitle>
                <div className="flex items-center space-x-2">
                  <Badge variant={service.isActive ? "default" : "secondary"}>
                    {service.isActive ? "Active" : "Inactive"}
                  </Badge>
                  <Switch
                    checked={service.isActive}
                    onCheckedChange={() => toggleServiceStatus(service.id)}
                  />
                </div>
              </div>
              <CardDescription className="text-sm">
                {service.description}
              </CardDescription>
            </CardHeader>
            
            <CardContent className="space-y-4">
              {/* Stats */}
              <div className="grid grid-cols-2 gap-4">
                <div className="text-center p-3 bg-blue-50 rounded-lg">
                  <div className="flex items-center justify-center mb-1">
                    <Calendar className="w-4 h-4 text-blue-600" />
                  </div>
                  <p className="text-lg font-semibold text-blue-600">{service.totalBookings}</p>
                  <p className="text-xs text-gray-600">Total Bookings</p>
                </div>
                <div className="text-center p-3 bg-orange-50 rounded-lg">
                  <div className="flex items-center justify-center mb-1">
                    <Clock className="w-4 h-4 text-orange-600" />
                  </div>
                  <p className="text-lg font-semibold text-orange-600">{service.pendingBookings}</p>
                  <p className="text-xs text-gray-600">Pending</p>
                </div>
              </div>

              {/* Service Details */}
              <div className="space-y-2">
                <div className="flex items-center text-sm text-gray-600">
                  <Clock className="w-4 h-4 mr-2" />
                  Duration: {service.estimatedTime}
                </div>
                <div className="flex items-start text-sm text-gray-600">
                  <FileText className="w-4 h-4 mr-2 mt-0.5" />
                  <div>
                    <p className="font-medium">Required Documents:</p>
                    <ul className="list-disc list-inside text-xs mt-1">
                      {service.requiredDocs.map((doc, index) => (
                        <li key={index}>{doc}</li>
                      ))}
                    </ul>
                  </div>
                </div>
              </div>

              {/* Actions */}
              <div className="flex space-x-2 pt-2">
                <Button 
                  variant="outline" 
                  size="sm" 
                  className="flex-1"
                  onClick={() => navigate("/bookings")}
                >
                  <Eye className="w-4 h-4 mr-1" />
                  View Bookings
                </Button>
                <Button 
                  variant="outline" 
                  size="sm" 
                  className="flex-1"
                  onClick={() => navigate("/time-slots")}
                >
                  <Settings className="w-4 h-4 mr-1" />
                  Manage Slots
                </Button>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>

      {/* Summary Stats */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6 mt-8">
        <Card>
          <CardContent className="p-6">
            <div className="flex items-center">
              <div className="p-2 bg-blue-50 rounded-lg">
                <FileText className="w-6 h-6 text-blue-600" />
              </div>
              <div className="ml-4">
                <p className="text-sm font-medium text-gray-600">Total Services</p>
                <p className="text-2xl font-bold text-gray-900">{services.length}</p>
              </div>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="p-6">
            <div className="flex items-center">
              <div className="p-2 bg-green-50 rounded-lg">
                <Users className="w-6 h-6 text-green-600" />
              </div>
              <div className="ml-4">
                <p className="text-sm font-medium text-gray-600">Active Services</p>
                <p className="text-2xl font-bold text-gray-900">
                  {services.filter(s => s.isActive).length}
                </p>
              </div>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="p-6">
            <div className="flex items-center">
              <div className="p-2 bg-purple-50 rounded-lg">
                <Calendar className="w-6 h-6 text-purple-600" />
              </div>
              <div className="ml-4">
                <p className="text-sm font-medium text-gray-600">Total Bookings</p>
                <p className="text-2xl font-bold text-gray-900">
                  {services.reduce((sum, service) => sum + service.totalBookings, 0)}
                </p>
              </div>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="p-6">
            <div className="flex items-center">
              <div className="p-2 bg-orange-50 rounded-lg">
                <Clock className="w-6 h-6 text-orange-600" />
              </div>
              <div className="ml-4">
                <p className="text-sm font-medium text-gray-600">Pending Reviews</p>
                <p className="text-2xl font-bold text-gray-900">
                  {services.reduce((sum, service) => sum + service.pendingBookings, 0)}
                </p>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
};

export default Services;
