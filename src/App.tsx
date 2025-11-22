import React, { useState, useEffect } from 'react';
import { Search, ShoppingCart, Star, MapPin, Clock, User, ArrowLeft, Plus, Minus, Trash2, CreditCard, DollarSign, CheckCircle, Calendar, Phone, Mail, Lock, Eye, EyeOff, Store, Settings, Edit, Save, X } from 'lucide-react';
import { Button } from './components/ui/button';
import { Input } from './components/ui/input';
import { Card, CardContent, CardHeader, CardTitle } from './components/ui/card';
import { Badge } from './components/ui/badge';
import { Avatar, AvatarFallback, AvatarImage } from './components/ui/avatar';
import { Separator } from './components/ui/separator';
import { Label } from './components/ui/label';
import { RadioGroup, RadioGroupItem } from './components/ui/radio-group';
import { Textarea } from './components/ui/textarea';
import { ImageWithFallback } from './components/figma/ImageWithFallback';

// Types
interface Service {
  id: string;
  name: string;
  description: string;
  price: number;
  image: string;
  category: string;
  duration?: string;
}

interface Provider {
  id: string;
  name: string;
  image: string;
  rating: number;
  reviewCount: number;
  deliveryTime: string;
  location: string;
  services: Service[];
}

interface CartItem extends Service {
  quantity: number;
  providerId: string;
  providerName: string;
}

interface User {
  name: string;
  address: string;
  phone: string;
  email: string;
}

interface AuthUser {
  username: string;
  role: 'customer' | 'provider';
  name: string;
  email: string;
  phone?: string;
  address?: string;
  businessName?: string;
  providerId?: string;
}

// Screen types
type Screen = 'loader' | 'login' | 'register-customer' | 'register-provider' | 'home' | 'provider' | 'cart' | 'auth' | 'payment' | 'confirmation' | 'provider-dashboard' | 'add-service';

export default function App() {
  const [currentScreen, setCurrentScreen] = useState<Screen>('loader');
  const [authUser, setAuthUser] = useState<AuthUser | null>(null);
  const [selectedProvider, setSelectedProvider] = useState<Provider | null>(null);
  const [cart, setCart] = useState<CartItem[]>([]);
  const [user, setUser] = useState<User | null>(null);
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('');
  const [paymentMethod, setPaymentMethod] = useState('credit');

  // Login states
  const [loginForm, setLoginForm] = useState({ username: '', password: '', role: 'customer' as 'customer' | 'provider' });
  const [showPassword, setShowPassword] = useState(false);
  const [loginError, setLoginError] = useState('');

  // Register states
  const [registerCustomerForm, setRegisterCustomerForm] = useState({
    username: '',
    password: '',
    confirmPassword: '',
    name: '',
    email: '',
    phone: '',
    address: ''
  });
  const [registerProviderForm, setRegisterProviderForm] = useState({
    username: '',
    password: '',
    confirmPassword: '',
    name: '',
    email: '',
    phone: '',
    businessName: '',
    location: '',
    description: ''
  });
  const [registerError, setRegisterError] = useState('');

  // Provider dashboard states
  const [providers, setProviders] = useState<Provider[]>([]);
  const [newServiceForm, setNewServiceForm] = useState({
    name: '',
    description: '',
    price: '',
    image: '',
    category: 'decoration',
    duration: ''
  });

  // Mock data
  const categories = [
    { id: 'all', name: 'Todos', icon: '🎉' },
    { id: 'birthday', name: 'Cumpleaños', icon: '🎂' },
    { id: 'kids', name: 'Infantiles', icon: '🧸' },
    { id: 'decoration', name: 'Decoración', icon: '🎈' },
    { id: 'catering', name: 'Catering', icon: '🍰' },
    { id: 'entertainment', name: 'Animación', icon: '🎭' },
    { id: 'music', name: 'Música', icon: '🎵' },
    { id: 'photography', name: 'Fotografía', icon: '📸' },
    { id: 'venue', name: 'Locales', icon: '🏢' },
    { id: 'services', name: 'Servicios', icon: '⚙️' }
  ];

  const initialProviders: Provider[] = [
    {
      id: '1',
      name: 'Fiesta Mágica',
      image: 'https://images.unsplash.com/photo-1654851364032-ca4d7a47341c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxiaXJ0aGRheSUyMHBhcnR5JTIwZGVjb3JhdGlvbiUyMGJhbGxvb25zfGVufDF8fHx8MTc1NTUzMzM0NXww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
      rating: 4.8,
      reviewCount: 234,
      deliveryTime: '45-60 min',
      location: 'Providencia',
      services: [
        {
          id: 's1',
          name: 'Decoración con Globos Premium',
          description: 'Arco de globos, centro de mesa y decoración completa',
          price: 85000,
          image: 'https://images.unsplash.com/photo-1654851364032-ca4d7a47341c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxiaXJ0aGRheSUyMHBhcnR5JTIwZGVjb3JhdGlvbiUyMGJhbGxvb25zfGVufDF8fHx8MTc1NTUzMzM0NXww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
          category: 'decoration',
          duration: '3 horas'
        },
        {
          id: 's2',
          name: 'Alquiler de Local',
          description: 'Salón completamente equipado para 50 personas',
          price: 120000,
          image: 'https://images.unsplash.com/photo-1600854109241-46990389fb97?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwYXJ0eSUyMHZlbnVlJTIwcmVudGFsJTIwc3BhY2V8ZW58MXx8fHwxNzU1NTMzMzQ3fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
          category: 'venue',
          duration: '4 horas'
        },
        {
          id: 's15',
          name: 'Globos con Helio',
          description: 'Paquete de 50 globos con helio en colores temáticos',
          price: 25000,
          image: 'https://images.unsplash.com/photo-1729798997904-d50ef609ac00?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxoZWxpdW0lMjBiYWxsb29ucyUyMHBhcnR5JTIwZGVjb3JhdGlvbnxlbnwxfHx8fDE3NTU2MzA1ODJ8MA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
          category: 'decoration',
          duration: '1 día'
        },
        {
          id: 's16',
          name: 'Iluminación LED',
          description: 'Sistema de luces LED multicolor para ambientar el evento',
          price: 45000,
          image: 'https://images.unsplash.com/photo-1573524793986-ba272ecb60fa?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwYXJ0eSUyMGxpZ2h0aW5nJTIwZGlzY28lMjBsaWdodHN8ZW58MXx8fHwxNzU1NjMwNTc0fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
          category: 'services',
          duration: '4 horas'
        },
        {
          id: 's17',
          name: 'Arreglos Florales',
          description: 'Centros de mesa y decoración floral personalizada',
          price: 75000,
          image: 'https://images.unsplash.com/photo-1748546639062-3d804e66f325?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx3ZWRkaW5nJTIwZmxvd2VycyUyMGJvdXF1ZXQlMjBjZW50ZXJwaWVjZXxlbnwxfHx8fDE3NTU2MzA1NzN8MA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
          category: 'decoration',
          duration: '1 día'
        }
      ]
    },
    {
      id: '2',
      name: 'Diversión Total',
      image: 'https://images.unsplash.com/photo-1537627856721-321efceec2a2?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxjaGlsZHJlbiUyMHBhcnR5JTIwZW50ZXJ0YWlubWVudCUyMGNsb3dufGVufDF8fHx8MTc1NTUzMzM0NXww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
      rating: 4.6,
      reviewCount: 189,
      deliveryTime: '30-45 min',
      location: 'Las Condes',
      services: [
        {
          id: 's3',
          name: 'Animador Profesional',
          description: 'Show de 2 horas con juegos, magia y payasito',
          price: 65000,
          image: 'https://images.unsplash.com/photo-1537627856721-321efceec2a2?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxjaGlsZHJlbiUyMHBhcnR5JTIwZW50ZXJ0YWlubWVudCUyMGNsb3dufGVufDF8fHx8MTc1NTUzMzM0NXww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
          category: 'entertainment',
          duration: '2 horas'
        },
        {
          id: 's4',
          name: 'Equipo de Sonido',
          description: 'Parlantes, micrófono y música para toda la fiesta',
          price: 35000,
          image: 'https://images.unsplash.com/photo-1698602807831-81066d89ed41?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwYXJ0eSUyMG11c2ljJTIwZGolMjBlcXVpcG1lbnR8ZW58MXx8fHwxNzU1NTMzMzQ3fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
          category: 'music',
          duration: '4 horas'
        },
        {
          id: 's7',
          name: 'Juegos Inflables',
          description: 'Castillo inflable gigante para diversión sin límites',
          price: 95000,
          image: 'https://images.unsplash.com/photo-1635536392500-271b66664142?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxpbmZsYXRhYmxlJTIwYm91bmN5JTIwY2FzdGxlJTIwa2lkc3xlbnwxfHx8fDE3NTU2MzA1Njh8MA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
          category: 'kids',
          duration: '4 horas'
        },
        {
          id: 's8',
          name: 'Piñatas Temáticas',
          description: 'Piñatas personalizadas con dulces y sorpresas',
          price: 35000,
          image: 'https://images.unsplash.com/photo-1571584004609-3b9d08de5755?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwaW5hdGElMjBjaGlsZHJlbiUyMHBhcnR5JTIwY29sb3JmdWx8ZW58MXx8fHwxNzU1NjMwNTY4fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
          category: 'kids',
          duration: '1 día'
        },
        {
          id: 's9',
          name: 'Maquillaje Infantil',
          description: 'Pintacaritas y maquillaje artístico para niños',
          price: 40000,
          image: 'https://images.unsplash.com/photo-1643906748265-2e77049c0281?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxmYWNlJTIwcGFpbnRpbmclMjBjaGlsZHJlbiUyMG1ha2V1cHxlbnwxfHx8fDE3NTU2MzA1NzV8MA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
          category: 'kids',
          duration: '3 horas'
        },
        {
          id: 's10',
          name: 'Show de Burbujas',
          description: 'Espectáculo mágico con burbujas gigantes',
          price: 50000,
          image: 'https://images.unsplash.com/photo-1598455407664-a198955838f2?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxidWJibGUlMjBzaG93JTIwcGVyZm9ybWFuY2UlMjBraWRzfGVufDF8fHx8MTc1NTYzMDU3Nnww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
          category: 'entertainment',
          duration: '1 hora'
        }
      ]
    },
    {
      id: '3',
      name: 'Delicias & Sabores',
      image: 'https://images.unsplash.com/photo-1753532629345-e0ff1ff87a89?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxldmVudCUyMGNhdGVyaW5nJTIwZm9vZCUyMHBhcnR5fGVufDF8fHx8MTc1NTUzMzM0Nnww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
      rating: 4.9,
      reviewCount: 312,
      deliveryTime: '60-75 min',
      location: 'Ñuñoa',
      services: [
        {
          id: 's5',
          name: 'Torta Personalizada',
          description: 'Torta de 2 pisos con decoración temática',
          price: 45000,
          image: 'https://images.unsplash.com/photo-1553803867-48ac36024cba?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxraWRzJTIwYmlydGhkYXklMjBjYWtlJTIwY2VsZWJyYXRpb258ZW58MXx8fHwxNzU1NTMzMzQ4fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
          category: 'catering',
          duration: '1 día'
        },
        {
          id: 's6',
          name: 'Bocaditos para 30 personas',
          description: 'Variedad de bocaditos dulces y salados',
          price: 55000,
          image: 'https://images.unsplash.com/photo-1753532629345-e0ff1ff87a89?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxldmVudCUyMGNhdGVyaW5nJTIwZm9vZCUyMHBhcnR5fGVufDF8fHx8MTc1NTUzMzM0Nnww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
          category: 'catering',
          duration: '1 día'
        },
        {
          id: 's11',
          name: 'Candy Bar Completo',
          description: 'Mesa de dulces con decoración temática',
          price: 65000,
          image: 'https://images.unsplash.com/photo-1709549774212-17c34ebaedc1?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxjYW5keSUyMGJhciUyMHN3ZWV0cyUyMGRlc3NlcnQlMjB0YWJsZXxlbnwxfHx8fDE3NTU2MzA1Njl8MA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
          category: 'catering',
          duration: '1 día'
        },
        {
          id: 's12',
          name: 'Servicio de Bartender',
          description: 'Bartender profesional con barra completa',
          price: 80000,
          image: 'https://images.unsplash.com/photo-1720108404259-2addc1cf223c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxiYXJ0ZW5kZXIlMjBjb2NrdGFpbHMlMjBwYXJ0eSUyMGRyaW5rc3xlbnwxfHx8fDE3NTU2MzA1Njd8MA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
          category: 'services',
          duration: '4 horas'
        }
      ]
    },
    {
      id: '4',
      name: 'Producciones VIP',
      image: 'https://images.unsplash.com/photo-1627580158782-ecd7b8a16326?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwYXJ0eSUyMHBob3RvZ3JhcGhlciUyMHdlZGRpbmclMjBldmVudHN8ZW58MXx8fHwxNzU1NjMwNTY2fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
      rating: 4.7,
      reviewCount: 156,
      deliveryTime: '90-120 min',
      location: 'Vitacura',
      services: [
        {
          id: 's13',
          name: 'Fotografía Profesional',
          description: 'Sesión fotográfica completa del evento',
          price: 120000,
          image: 'https://images.unsplash.com/photo-1627580158782-ecd7b8a16326?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwYXJ0eSUyMHBob3RvZ3JhcGhlciUyMHdlZGRpbmclMjBldmVudHN8ZW58MXx8fHwxNzU1NjMwNTY2fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
          category: 'photography',
          duration: '4 horas'
        },
        {
          id: 's14',
          name: 'DJ Profesional',
          description: 'DJ con equipo completo y música personalizada',
          price: 90000,
          image: 'https://images.unsplash.com/photo-1675709341324-9c98573f9281?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxkaiUyMHR1cm50YWJsZXMlMjBwYXJ0eSUyMG11c2ljfGVufDF8fHx8MTc1NTYzMDU2Nnww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
          category: 'music',
          duration: '5 horas'
        },
        {
          id: 's18',
          name: 'Organización Completa',
          description: 'Planificación y coordinación total del evento',
          price: 200000,
          image: 'https://images.unsplash.com/photo-1712903276040-c99b32a057eb?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwYXJ0eSUyMHBsYW5uaW5nJTIwb3JnYW5pemVyJTIwY2hlY2tsaXN0fGVufDF8fHx8MTc1NTYzMDU4Mnww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
          category: 'services',
          duration: '1 semana'
        }
      ]
    },
    {
      id: '5',
      name: 'Eventos Outdoor',
      image: 'https://images.unsplash.com/photo-1694578345441-c8ebfb5258fc?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwYXJ0eSUyMHRlbnQlMjBvdXRkb29yJTIwZXZlbnR8ZW58MXx8fHwxNzU1NjMwNTc1fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
      rating: 4.5,
      reviewCount: 98,
      deliveryTime: '120-180 min',
      location: 'San Bernardo',
      services: [
        {
          id: 's19',
          name: 'Carpa para Eventos',
          description: 'Carpa grande para eventos al aire libre',
          price: 150000,
          image: 'https://images.unsplash.com/photo-1694578345441-c8ebfb5258fc?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwYXJ0eSUyMHRlbnQlMjBvdXRkb29yJTIwZXZlbnR8ZW58MXx8fHwxNzU1NjMwNTc1fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
          category: 'venue',
          duration: '1 día'
        },
        {
          id: 's20',
          name: 'Mesas y Sillas',
          description: 'Alquiler de mobiliario completo para 50 personas',
          price: 45000,
          image: 'https://images.unsplash.com/photo-1706611430592-6d3bb6e7456f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwYXJ0eSUyMHRhYmxlcyUyMGNoYWlycyUyMHJlbnRhbHxlbnwxfHx8fDE3NTU2MzA1NzZ8MA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
          category: 'venue',
          duration: '1 día'
        }
      ]
    },
    {
      id: '6',
      name: 'Servicios Especiales',
      image: 'https://images.unsplash.com/photo-1676265266086-aa863c7bd3cc?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwYXJ0eSUyMHRyYW5zcG9ydGF0aW9uJTIwYnVzJTIwbGltb3VzaW5lfGVufDF8fHx8MTc1NTYzMDU4MHww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
      rating: 4.4,
      reviewCount: 87,
      deliveryTime: '60-90 min',
      location: 'Maipú',
      services: [
        {
          id: 's21',
          name: 'Transporte VIP',
          description: 'Servicio de transporte para invitados',
          price: 100000,
          image: 'https://images.unsplash.com/photo-1676265266086-aa863c7bd3cc?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwYXJ0eSUyMHRyYW5zcG9ydGF0aW9uJTIwYnVzJTIwbGltb3VzaW5lfGVufDF8fHx8MTc1NTYzMDU4MHww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
          category: 'services',
          duration: '4 horas'
        },
        {
          id: 's22',
          name: 'Limpieza Post-Evento',
          description: 'Servicio completo de limpieza después del evento',
          price: 60000,
          image: 'https://images.unsplash.com/photo-1562050061-9f9c55b807e2?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxjbGVhbmluZyUyMHNlcnZpY2UlMjBwYXJ0eSUyMGNsZWFudXB8ZW58MXx8fHwxNzU1NjMwNTgxfDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
          category: 'services',
          duration: '2 horas'
        },
        {
          id: 's23',
          name: 'Seguridad Privada',
          description: 'Personal de seguridad para eventos grandes',
          price: 85000,
          image: 'https://images.unsplash.com/photo-1652148555073-4b1d2ecd664c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxldmVudCUyMHNlY3VyaXR5JTIwZ3VhcmQlMjBzZXJ2aWNlfGVufDF8fHx8MTc1NTYzMDU4MXww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
          category: 'services',
          duration: '6 horas'
        }
      ]
    }
  ];

  // Effects
  useEffect(() => {
    const timer = setTimeout(() => {
      if (currentScreen === 'loader') {
        setCurrentScreen('login');
      }
    }, 3000);

    return () => clearTimeout(timer);
  }, [currentScreen]);

  useEffect(() => {
    setProviders(initialProviders);
  }, []);

  // Helper functions
  const formatPrice = (price: number) => {
    return new Intl.NumberFormat('es-CL', { style: 'currency', currency: 'CLP' }).format(price);
  };

  const generateId = () => {
    return Math.random().toString(36).substr(2, 9);
  };

  const handleLogin = (e: React.FormEvent) => {
    e.preventDefault();
    setLoginError('');

    if (loginForm.username === 'persona' && loginForm.password === '123') {
      const user: AuthUser = {
        username: loginForm.username,
        role: loginForm.role,
        name: loginForm.role === 'provider' ? 'Proveedor Demo' : 'Usuario Demo',
        email: 'demo@partyapp.com',
        phone: '+56912345678',
        providerId: loginForm.role === 'provider' ? '1' : undefined,
        businessName: loginForm.role === 'provider' ? 'Fiesta Mágica' : undefined
      };
      
      setAuthUser(user);
      
      if (loginForm.role === 'provider') {
        setCurrentScreen('provider-dashboard');
      } else {
        setCurrentScreen('home');
      }
    } else {
      setLoginError('Usuario o contraseña incorrectos');
    }
  };

  const handleRegisterCustomer = (e: React.FormEvent) => {
    e.preventDefault();
    setRegisterError('');

    if (registerCustomerForm.password !== registerCustomerForm.confirmPassword) {
      setRegisterError('Las contraseñas no coinciden');
      return;
    }

    if (registerCustomerForm.password.length < 3) {
      setRegisterError('La contraseña debe tener al menos 3 caracteres');
      return;
    }

    const user: AuthUser = {
      username: registerCustomerForm.username,
      role: 'customer',
      name: registerCustomerForm.name,
      email: registerCustomerForm.email,
      phone: registerCustomerForm.phone,
      address: registerCustomerForm.address
    };

    setAuthUser(user);
    setCurrentScreen('home');
  };

  const handleRegisterProvider = (e: React.FormEvent) => {
    e.preventDefault();
    setRegisterError('');

    if (registerProviderForm.password !== registerProviderForm.confirmPassword) {
      setRegisterError('Las contraseñas no coinciden');
      return;
    }

    if (registerProviderForm.password.length < 3) {
      setRegisterError('La contraseña debe tener al menos 3 caracteres');
      return;
    }

    const newProviderId = generateId();
    const newProvider: Provider = {
      id: newProviderId,
      name: registerProviderForm.businessName,
      image: 'https://images.unsplash.com/photo-1654851364032-ca4d7a47341c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxiaXJ0aGRheSUyMHBhcnR5JTIwZGVjb3JhdGlvbiUyMGJhbGxvb25zfGVufDF8fHx8MTc1NTUzMzM0NXww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
      rating: 5.0,
      reviewCount: 0,
      deliveryTime: '60-90 min',
      location: registerProviderForm.location,
      services: []
    };

    setProviders(prev => [...prev, newProvider]);

    const user: AuthUser = {
      username: registerProviderForm.username,
      role: 'provider',
      name: registerProviderForm.name,
      email: registerProviderForm.email,
      phone: registerProviderForm.phone,
      providerId: newProviderId,
      businessName: registerProviderForm.businessName
    };

    setAuthUser(user);
    setCurrentScreen('provider-dashboard');
  };

  const handleLogout = () => {
    setAuthUser(null);
    setCurrentScreen('login');
    setCart([]);
    setUser(null);
    setLoginForm({ username: '', password: '', role: 'customer' });
  };

  const addToCart = (service: Service, provider: Provider) => {
    const existingItem = cart.find(item => item.id === service.id && item.providerId === provider.id);
    
    if (existingItem) {
      setCart(cart.map(item => 
        item.id === service.id && item.providerId === provider.id
          ? { ...item, quantity: item.quantity + 1 }
          : item
      ));
    } else {
      setCart([...cart, {
        ...service,
        quantity: 1,
        providerId: provider.id,
        providerName: provider.name
      }]);
    }
  };

  const updateCartQuantity = (itemId: string, providerId: string, newQuantity: number) => {
    if (newQuantity <= 0) {
      setCart(cart.filter(item => !(item.id === itemId && item.providerId === providerId)));
    } else {
      setCart(cart.map(item =>
        item.id === itemId && item.providerId === providerId
          ? { ...item, quantity: newQuantity }
          : item
      ));
    }
  };

  const getCartTotal = () => {
    return cart.reduce((total, item) => total + (item.price * item.quantity), 0);
  };

  const filteredProviders = providers.filter(provider => {
    if (searchQuery && !provider.name.toLowerCase().includes(searchQuery.toLowerCase())) {
      return false;
    }
    if (selectedCategory && selectedCategory !== 'all') {
      return provider.services.some(service => service.category === selectedCategory);
    }
    return true;
  });

  const addNewService = (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!authUser?.providerId) return;

    const newService: Service = {
      id: generateId(),
      name: newServiceForm.name,
      description: newServiceForm.description,
      price: parseInt(newServiceForm.price),
      image: newServiceForm.image || 'https://images.unsplash.com/photo-1654851364032-ca4d7a47341c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxiaXJ0aGRheSUyMHBhcnR5JTIwZGVjb3JhdGlvbiUyMGJhbGxvb25zfGVufDF8fHx8MTc1NTUzMzM0NXww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
      category: newServiceForm.category,
      duration: newServiceForm.duration
    };

    setProviders(prev => prev.map(provider => 
      provider.id === authUser.providerId
        ? { ...provider, services: [...provider.services, newService] }
        : provider
    ));

    setNewServiceForm({
      name: '',
      description: '',
      price: '',
      image: '',
      category: 'decoration',
      duration: ''
    });

    setCurrentScreen('provider-dashboard');
  };

  const getCurrentProviderData = () => {
    return providers.find(p => p.id === authUser?.providerId);
  };

  // Screen components
  const LoaderScreen = () => (
    <div className="min-h-screen bg-gradient-to-br from-orange-light via-yellow-light to-pink-light flex items-center justify-center">
      <div className="text-center">
        <div className="relative mb-8">
          <div className="w-24 h-24 mx-auto bg-white rounded-full flex items-center justify-center shadow-lg">
            <span className="text-4xl">🎉</span>
          </div>
          <div className="absolute inset-0 w-24 h-24 mx-auto border-4 border-orange rounded-full border-t-transparent animate-spin"></div>
        </div>
        <h1 className="text-3xl font-bold text-white mb-2">PartyApp</h1>
        <p className="text-white/80">Organizando el evento perfecto...</p>
        <div className="mt-6 flex justify-center">
          <div className="flex space-x-1">
            <div className="w-2 h-2 bg-white rounded-full animate-bounce"></div>
            <div className="w-2 h-2 bg-white rounded-full animate-bounce" style={{ animationDelay: '0.1s' }}></div>
            <div className="w-2 h-2 bg-white rounded-full animate-bounce" style={{ animationDelay: '0.2s' }}></div>
          </div>
        </div>
      </div>
    </div>
  );

  const LoginScreen = () => (
    <div className="min-h-screen bg-gradient-to-br from-orange-light/20 to-yellow-light/20 flex items-center justify-center p-4">
      <Card className="w-full max-w-md border-orange-light/30 shadow-xl">
        <CardHeader className="text-center pb-4">
          <div className="w-16 h-16 mx-auto bg-orange rounded-full flex items-center justify-center mb-4">
            <span className="text-2xl">🎉</span>
          </div>
          <CardTitle className="text-2xl text-orange">PartyApp</CardTitle>
          <p className="text-muted-foreground">Inicia sesión para continuar</p>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleLogin} className="space-y-4">
            <div>
              <Label htmlFor="role">Tipo de usuario</Label>
              <RadioGroup 
                value={loginForm.role} 
                onValueChange={(value: 'customer' | 'provider') => setLoginForm({...loginForm, role: value})}
                className="flex gap-4 mt-2"
              >
                <div className="flex items-center space-x-2">
                  <RadioGroupItem value="customer" id="customer" />
                  <Label htmlFor="customer" className="cursor-pointer">Cliente</Label>
                </div>
                <div className="flex items-center space-x-2">
                  <RadioGroupItem value="provider" id="provider" />
                  <Label htmlFor="provider" className="cursor-pointer">Proveedor</Label>
                </div>
              </RadioGroup>
            </div>

            <div>
              <Label htmlFor="username">Usuario</Label>
              <div className="relative">
                <User className="absolute left-3 top-1/2 transform -translate-y-1/2 text-muted-foreground h-4 w-4" />
                <Input
                  id="username"
                  type="text"
                  value={loginForm.username}
                  onChange={(e) => setLoginForm({...loginForm, username: e.target.value})}
                  placeholder="Ingresa tu usuario"
                  className="pl-10 border-orange-light/30 focus:border-orange"
                  required
                />
              </div>
            </div>
            
            <div>
              <Label htmlFor="password">Contraseña</Label>
              <div className="relative">
                <Lock className="absolute left-3 top-1/2 transform -translate-y-1/2 text-muted-foreground h-4 w-4" />
                <Input
                  id="password"
                  type={showPassword ? "text" : "password"}
                  value={loginForm.password}
                  onChange={(e) => setLoginForm({...loginForm, password: e.target.value})}
                  placeholder="Ingresa tu contraseña"
                  className="pl-10 pr-10 border-orange-light/30 focus:border-orange"
                  required
                />
                <Button
                  type="button"
                  variant="ghost"
                  size="sm"
                  onClick={() => setShowPassword(!showPassword)}
                  className="absolute right-1 top-1/2 transform -translate-y-1/2 h-7 w-7 p-0"
                >
                  {showPassword ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
                </Button>
              </div>
            </div>

            {loginError && (
              <div className="text-destructive text-sm text-center bg-destructive/10 p-2 rounded">
                {loginError}
              </div>
            )}

            <Button 
              type="submit" 
              className="w-full bg-orange hover:bg-orange-light text-white"
            >
              Iniciar sesión
            </Button>
            
            <div className="text-center space-y-2">
              <p className="text-sm text-muted-foreground">¿No tienes cuenta?</p>
              <div className="flex gap-2">
                <Button 
                  type="button"
                  variant="outline" 
                  size="sm"
                  onClick={() => setCurrentScreen('register-customer')}
                  className="flex-1 border-orange text-orange hover:bg-orange hover:text-white"
                >
                  Registrar Cliente
                </Button>
                <Button 
                  type="button"
                  variant="outline" 
                  size="sm"
                  onClick={() => setCurrentScreen('register-provider')}
                  className="flex-1 border-orange text-orange hover:bg-orange hover:text-white"
                >
                  Registrar Proveedor
                </Button>
              </div>
            </div>
            
            <div className="text-center">
              <p className="text-sm text-muted-foreground mb-2">Credenciales de prueba:</p>
              <p className="text-xs text-muted-foreground">Usuario: <strong>persona</strong></p>
              <p className="text-xs text-muted-foreground">Contraseña: <strong>123</strong></p>
            </div>
          </form>
        </CardContent>
      </Card>
    </div>
  );

  const RegisterCustomerScreen = () => (
    <div className="min-h-screen bg-gradient-to-br from-orange-light/20 to-yellow-light/20 flex items-center justify-center p-4">
      <Card className="w-full max-w-md border-orange-light/30 shadow-xl">
        <CardHeader className="text-center pb-4">
          <div className="w-16 h-16 mx-auto bg-orange rounded-full flex items-center justify-center mb-4">
            <span className="text-2xl">👤</span>
          </div>
          <CardTitle className="text-2xl text-orange">Registro Cliente</CardTitle>
          <p className="text-muted-foreground">Crea tu cuenta para comenzar</p>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleRegisterCustomer} className="space-y-4">
            <div>
              <Label htmlFor="reg-username">Nombre de usuario</Label>
              <Input
                id="reg-username"
                type="text"
                value={registerCustomerForm.username}
                onChange={(e) => setRegisterCustomerForm({...registerCustomerForm, username: e.target.value})}
                placeholder="Tu nombre de usuario"
                className="border-orange-light/30 focus:border-orange"
                required
              />
            </div>
            
            <div>
              <Label htmlFor="reg-name">Nombre completo</Label>
              <Input
                id="reg-name"
                type="text"
                value={registerCustomerForm.name}
                onChange={(e) => setRegisterCustomerForm({...registerCustomerForm, name: e.target.value})}
                placeholder="Tu nombre completo"
                className="border-orange-light/30 focus:border-orange"
                required
              />
            </div>
            
            <div>
              <Label htmlFor="reg-email">Correo electrónico</Label>
              <Input
                id="reg-email"
                type="email"
                value={registerCustomerForm.email}
                onChange={(e) => setRegisterCustomerForm({...registerCustomerForm, email: e.target.value})}
                placeholder="tu@email.com"
                className="border-orange-light/30 focus:border-orange"
                required
              />
            </div>
            
            <div>
              <Label htmlFor="reg-phone">Teléfono</Label>
              <Input
                id="reg-phone"
                type="tel"
                value={registerCustomerForm.phone}
                onChange={(e) => setRegisterCustomerForm({...registerCustomerForm, phone: e.target.value})}
                placeholder="+56 9 1234 5678"
                className="border-orange-light/30 focus:border-orange"
                required
              />
            </div>
            
            <div>
              <Label htmlFor="reg-address">Dirección</Label>
              <Input
                id="reg-address"
                type="text"
                value={registerCustomerForm.address}
                onChange={(e) => setRegisterCustomerForm({...registerCustomerForm, address: e.target.value})}
                placeholder="Tu dirección"
                className="border-orange-light/30 focus:border-orange"
                required
              />
            </div>
            
            <div>
              <Label htmlFor="reg-password">Contraseña</Label>
              <Input
                id="reg-password"
                type="password"
                value={registerCustomerForm.password}
                onChange={(e) => setRegisterCustomerForm({...registerCustomerForm, password: e.target.value})}
                placeholder="Tu contraseña"
                className="border-orange-light/30 focus:border-orange"
                required
              />
            </div>
            
            <div>
              <Label htmlFor="reg-confirm-password">Confirmar contraseña</Label>
              <Input
                id="reg-confirm-password"
                type="password"
                value={registerCustomerForm.confirmPassword}
                onChange={(e) => setRegisterCustomerForm({...registerCustomerForm, confirmPassword: e.target.value})}
                placeholder="Confirma tu contraseña"
                className="border-orange-light/30 focus:border-orange"
                required
              />
            </div>

            {registerError && (
              <div className="text-destructive text-sm text-center bg-destructive/10 p-2 rounded">
                {registerError}
              </div>
            )}

            <Button 
              type="submit" 
              className="w-full bg-orange hover:bg-orange-light text-white"
            >
              Registrarse
            </Button>
            
            <Button 
              type="button"
              variant="outline" 
              onClick={() => setCurrentScreen('login')}
              className="w-full border-orange text-orange hover:bg-orange hover:text-white"
            >
              Volver al login
            </Button>
          </form>
        </CardContent>
      </Card>
    </div>
  );

  const RegisterProviderScreen = () => (
    <div className="min-h-screen bg-gradient-to-br from-orange-light/20 to-yellow-light/20 flex items-center justify-center p-4">
      <Card className="w-full max-w-md border-orange-light/30 shadow-xl">
        <CardHeader className="text-center pb-4">
          <div className="w-16 h-16 mx-auto bg-orange rounded-full flex items-center justify-center mb-4">
            <span className="text-2xl">🏪</span>
          </div>
          <CardTitle className="text-2xl text-orange">Registro Proveedor</CardTitle>
          <p className="text-muted-foreground">Únete como proveedor de servicios</p>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleRegisterProvider} className="space-y-4">
            <div>
              <Label htmlFor="prov-username">Nombre de usuario</Label>
              <Input
                id="prov-username"
                type="text"
                value={registerProviderForm.username}
                onChange={(e) => setRegisterProviderForm({...registerProviderForm, username: e.target.value})}
                placeholder="Tu nombre de usuario"
                className="border-orange-light/30 focus:border-orange"
                required
              />
            </div>
            
            <div>
              <Label htmlFor="prov-name">Nombre del responsable</Label>
              <Input
                id="prov-name"
                type="text"
                value={registerProviderForm.name}
                onChange={(e) => setRegisterProviderForm({...registerProviderForm, name: e.target.value})}
                placeholder="Tu nombre completo"
                className="border-orange-light/30 focus:border-orange"
                required
              />
            </div>
            
            <div>
              <Label htmlFor="prov-business">Nombre del negocio</Label>
              <Input
                id="prov-business"
                type="text"
                value={registerProviderForm.businessName}
                onChange={(e) => setRegisterProviderForm({...registerProviderForm, businessName: e.target.value})}
                placeholder="Nombre de tu empresa"
                className="border-orange-light/30 focus:border-orange"
                required
              />
            </div>
            
            <div>
              <Label htmlFor="prov-email">Correo electrónico</Label>
              <Input
                id="prov-email"
                type="email"
                value={registerProviderForm.email}
                onChange={(e) => setRegisterProviderForm({...registerProviderForm, email: e.target.value})}
                placeholder="tu@empresa.com"
                className="border-orange-light/30 focus:border-orange"
                required
              />
            </div>
            
            <div>
              <Label htmlFor="prov-phone">Teléfono</Label>
              <Input
                id="prov-phone"
                type="tel"
                value={registerProviderForm.phone}
                onChange={(e) => setRegisterProviderForm({...registerProviderForm, phone: e.target.value})}
                placeholder="+56 9 1234 5678"
                className="border-orange-light/30 focus:border-orange"
                required
              />
            </div>
            
            <div>
              <Label htmlFor="prov-location">Ubicación</Label>
              <Input
                id="prov-location"
                type="text"
                value={registerProviderForm.location}
                onChange={(e) => setRegisterProviderForm({...registerProviderForm, location: e.target.value})}
                placeholder="Comuna donde operas"
                className="border-orange-light/30 focus:border-orange"
                required
              />
            </div>
            
            <div>
              <Label htmlFor="prov-description">Descripción del negocio</Label>
              <Textarea
                id="prov-description"
                value={registerProviderForm.description}
                onChange={(e) => setRegisterProviderForm({...registerProviderForm, description: e.target.value})}
                placeholder="Describe brevemente tu negocio"
                className="border-orange-light/30 focus:border-orange"
              />
            </div>
            
            <div>
              <Label htmlFor="prov-password">Contraseña</Label>
              <Input
                id="prov-password"
                type="password"
                value={registerProviderForm.password}
                onChange={(e) => setRegisterProviderForm({...registerProviderForm, password: e.target.value})}
                placeholder="Tu contraseña"
                className="border-orange-light/30 focus:border-orange"
                required
              />
            </div>
            
            <div>
              <Label htmlFor="prov-confirm-password">Confirmar contraseña</Label>
              <Input
                id="prov-confirm-password"
                type="password"
                value={registerProviderForm.confirmPassword}
                onChange={(e) => setRegisterProviderForm({...registerProviderForm, confirmPassword: e.target.value})}
                placeholder="Confirma tu contraseña"
                className="border-orange-light/30 focus:border-orange"
                required
              />
            </div>

            {registerError && (
              <div className="text-destructive text-sm text-center bg-destructive/10 p-2 rounded">
                {registerError}
              </div>
            )}

            <Button 
              type="submit" 
              className="w-full bg-orange hover:bg-orange-light text-white"
            >
              Registrarse como Proveedor
            </Button>
            
            <Button 
              type="button"
              variant="outline" 
              onClick={() => setCurrentScreen('login')}
              className="w-full border-orange text-orange hover:bg-orange hover:text-white"
            >
              Volver al login
            </Button>
          </form>
        </CardContent>
      </Card>
    </div>
  );

  const ProviderDashboardScreen = () => {
    const providerData = getCurrentProviderData();
    if (!providerData) return null;

    return (
      <div className="min-h-screen bg-gradient-to-b from-orange-light/20 to-yellow-light/20">
        {/* Header */}
        <div className="bg-white shadow-sm border-b border-orange-light/30">
          <div className="max-w-6xl mx-auto px-4 py-4">
            <div className="flex items-center justify-between mb-4">
              <div>
                <h1 className="text-2xl font-bold text-orange">Panel de Proveedor</h1>
                <p className="text-sm text-muted-foreground">Gestiona tus servicios - {providerData.name}</p>
              </div>
              <div className="flex items-center gap-2">
                <Button 
                  variant="outline" 
                  size="sm" 
                  onClick={() => setCurrentScreen('add-service')}
                  className="border-orange text-orange hover:bg-orange hover:text-white"
                >
                  <Plus className="h-4 w-4 mr-1" />
                  Agregar Servicio
                </Button>
                <Button 
                  variant="outline" 
                  size="sm" 
                  onClick={handleLogout}
                  className="border-orange text-orange hover:bg-orange hover:text-white"
                >
                  <User className="h-4 w-4" />
                </Button>
              </div>
            </div>
          </div>
        </div>

        {/* Dashboard Content */}
        <div className="max-w-6xl mx-auto px-4 py-6">
          {/* Stats Cards */}
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
            <Card className="border-orange-light/30">
              <CardContent className="p-6">
                <div className="flex items-center gap-3">
                  <div className="w-12 h-12 bg-orange/10 rounded-full flex items-center justify-center">
                    <Star className="h-6 w-6 text-orange" />
                  </div>
                  <div>
                    <p className="text-2xl font-bold">{providerData.rating}</p>
                    <p className="text-sm text-muted-foreground">Calificación</p>
                  </div>
                </div>
              </CardContent>
            </Card>
            
            <Card className="border-orange-light/30">
              <CardContent className="p-6">
                <div className="flex items-center gap-3">
                  <div className="w-12 h-12 bg-yellow/10 rounded-full flex items-center justify-center">
                    <Store className="h-6 w-6 text-yellow" />
                  </div>
                  <div>
                    <p className="text-2xl font-bold">{providerData.services.length}</p>
                    <p className="text-sm text-muted-foreground">Servicios</p>
                  </div>
                </div>
              </CardContent>
            </Card>
            
            <Card className="border-orange-light/30">
              <CardContent className="p-6">
                <div className="flex items-center gap-3">
                  <div className="w-12 h-12 bg-pink/10 rounded-full flex items-center justify-center">
                    <User className="h-6 w-6 text-pink" />
                  </div>
                  <div>
                    <p className="text-2xl font-bold">{providerData.reviewCount}</p>
                    <p className="text-sm text-muted-foreground">Reseñas</p>
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>

          {/* Services Management */}
          <Card className="border-orange-light/30">
            <CardHeader>
              <CardTitle className="flex items-center justify-between">
                <span>Mis Servicios</span>
                <Button 
                  onClick={() => setCurrentScreen('add-service')}
                  className="bg-orange hover:bg-orange-light text-white"
                >
                  <Plus className="h-4 w-4 mr-1" />
                  Nuevo Servicio
                </Button>
              </CardTitle>
            </CardHeader>
            <CardContent>
              {providerData.services.length === 0 ? (
                <div className="text-center py-8">
                  <Store className="h-16 w-16 mx-auto text-orange/50 mb-4" />
                  <h3 className="text-lg font-bold mb-2">No tienes servicios aún</h3>
                  <p className="text-muted-foreground mb-4">Agrega tu primer servicio para comenzar a recibir pedidos</p>
                  <Button 
                    onClick={() => setCurrentScreen('add-service')}
                    className="bg-orange hover:bg-orange-light text-white"
                  >
                    <Plus className="h-4 w-4 mr-1" />
                    Agregar Primer Servicio
                  </Button>
                </div>
              ) : (
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                  {providerData.services.map((service) => (
                    <Card key={service.id} className="border-orange-light/30">
                      <div className="relative h-32">
                        <ImageWithFallback
                          src={service.image}
                          alt={service.name}
                          className="w-full h-full object-cover rounded-t"
                        />
                      </div>
                      <CardContent className="p-4">
                        <h3 className="font-bold mb-1">{service.name}</h3>
                        <p className="text-sm text-muted-foreground mb-2 line-clamp-2">{service.description}</p>
                        <div className="flex items-center justify-between mb-3">
                          <div>
                            <p className="font-bold text-orange">{formatPrice(service.price)}</p>
                            {service.duration && (
                              <p className="text-xs text-muted-foreground">{service.duration}</p>
                            )}
                          </div>
                          <Badge variant="secondary" className="bg-yellow-light text-yellow-800">
                            {categories.find(cat => cat.id === service.category)?.name || service.category}
                          </Badge>
                        </div>
                        <Button
                          size="sm"
                          variant="outline"
                          className="w-full border-orange text-orange hover:bg-orange hover:text-white"
                        >
                          <Edit className="h-4 w-4 mr-1" />
                          Editar
                        </Button>
                      </CardContent>
                    </Card>
                  ))}
                </div>
              )}
            </CardContent>
          </Card>
        </div>
      </div>
    );
  };

  const AddServiceScreen = () => (
    <div className="min-h-screen bg-white">
      {/* Header */}
      <div className="border-b border-orange-light/30 bg-white">
        <div className="max-w-6xl mx-auto px-4 py-4">
          <div className="flex items-center gap-3">
            <Button
              variant="ghost"
              size="sm"
              onClick={() => setCurrentScreen('provider-dashboard')}
            >
              <ArrowLeft className="h-4 w-4" />
            </Button>
            <h1 className="text-xl font-bold">Agregar Nuevo Servicio</h1>
          </div>
        </div>
      </div>

      <div className="max-w-2xl mx-auto px-4 py-6">
        <form onSubmit={addNewService} className="space-y-6">
          <Card className="border-orange-light/30">
            <CardHeader>
              <CardTitle>Información del Servicio</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div>
                <Label htmlFor="service-name">Nombre del servicio</Label>
                <Input
                  id="service-name"
                  value={newServiceForm.name}
                  onChange={(e) => setNewServiceForm({...newServiceForm, name: e.target.value})}
                  placeholder="Ej: Animación infantil completa"
                  className="border-orange-light/30 focus:border-orange"
                  required
                />
              </div>
              
              <div>
                <Label htmlFor="service-description">Descripción</Label>
                <Textarea
                  id="service-description"
                  value={newServiceForm.description}
                  onChange={(e) => setNewServiceForm({...newServiceForm, description: e.target.value})}
                  placeholder="Describe detalladamente tu servicio"
                  className="border-orange-light/30 focus:border-orange"
                  required
                />
              </div>
              
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <Label htmlFor="service-price">Precio (CLP)</Label>
                  <Input
                    id="service-price"
                    type="number"
                    value={newServiceForm.price}
                    onChange={(e) => setNewServiceForm({...newServiceForm, price: e.target.value})}
                    placeholder="50000"
                    className="border-orange-light/30 focus:border-orange"
                    required
                  />
                </div>
                
                <div>
                  <Label htmlFor="service-duration">Duración</Label>
                  <Input
                    id="service-duration"
                    value={newServiceForm.duration}
                    onChange={(e) => setNewServiceForm({...newServiceForm, duration: e.target.value})}
                    placeholder="Ej: 2 horas"
                    className="border-orange-light/30 focus:border-orange"
                  />
                </div>
              </div>
              
              <div>
                <Label htmlFor="service-category">Categoría</Label>
                <select 
                  id="service-category"
                  value={newServiceForm.category} 
                  onChange={(e) => setNewServiceForm({...newServiceForm, category: e.target.value})}
                  className="w-full p-2 border border-orange-light/30 focus:border-orange rounded-md bg-white"
                  required
                >
                  {categories.filter(cat => cat.id !== 'all').map((category) => (
                    <option key={category.id} value={category.id}>
                      {category.icon} {category.name}
                    </option>
                  ))}
                </select>
              </div>
              
              <div>
                <Label htmlFor="service-image">URL de imagen (opcional)</Label>
                <Input
                  id="service-image"
                  type="url"
                  value={newServiceForm.image}
                  onChange={(e) => setNewServiceForm({...newServiceForm, image: e.target.value})}
                  placeholder="https://ejemplo.com/imagen.jpg"
                  className="border-orange-light/30 focus:border-orange"
                />
                <p className="text-xs text-muted-foreground mt-1">
                  Si no proporcionas una imagen, se usará una imagen por defecto
                </p>
              </div>
            </CardContent>
          </Card>

          <div className="flex gap-4">
            <Button 
              type="submit" 
              className="flex-1 bg-orange hover:bg-orange-light text-white"
            >
              <Save className="h-4 w-4 mr-1" />
              Guardar Servicio
            </Button>
            <Button 
              type="button"
              variant="outline" 
              onClick={() => setCurrentScreen('provider-dashboard')}
              className="border-orange text-orange hover:bg-orange hover:text-white"
            >
              <X className="h-4 w-4 mr-1" />
              Cancelar
            </Button>
          </div>
        </form>
      </div>
    </div>
  );

  const HomeScreen = () => (
    <div className="min-h-screen bg-gradient-to-b from-orange-light/20 to-yellow-light/20">
      {/* Header */}
      <div className="bg-white shadow-sm border-b border-orange-light/30">
        <div className="max-w-6xl mx-auto px-4 py-4">
          <div className="flex items-center justify-between mb-4">
            <div>
              <h1 className="text-2xl font-bold text-orange">PartyApp</h1>
              <p className="text-sm text-muted-foreground">
                Organiza el evento perfecto - Bienvenido {authUser?.name}
              </p>
            </div>
            <div className="flex items-center gap-2">
              <Button 
                variant="outline" 
                size="sm" 
                onClick={() => setCurrentScreen('cart')}
                className="relative border-orange text-orange hover:bg-orange hover:text-white"
              >
                <ShoppingCart className="h-4 w-4" />
                {cart.length > 0 && (
                  <Badge className="absolute -top-2 -right-2 h-5 w-5 p-0 bg-yellow text-xs">
                    {cart.reduce((sum, item) => sum + item.quantity, 0)}
                  </Badge>
                )}
              </Button>
              <Button 
                variant="outline" 
                size="sm" 
                onClick={handleLogout}
                className="border-orange text-orange hover:bg-orange hover:text-white"
              >
                <User className="h-4 w-4" />
              </Button>
            </div>
          </div>
          
          {/* Search */}
          <div className="relative max-w-md">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-muted-foreground h-4 w-4" />
            <Input
              placeholder="Buscar proveedores..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="pl-10 border-orange-light/30 focus:border-orange"
            />
          </div>
        </div>
      </div>

      {/* Categories */}
      <div className="max-w-6xl mx-auto px-4 py-4">
        <div className="flex gap-2 overflow-x-auto pb-2">
          {categories.map((category) => (
            <Button
              key={category.id}
              variant={selectedCategory === category.id ? "default" : "outline"}
              size="sm"
              onClick={() => setSelectedCategory(category.id === selectedCategory ? '' : category.id)}
              className={`whitespace-nowrap ${
                selectedCategory === category.id 
                  ? 'bg-orange text-white hover:bg-orange-light' 
                  : 'border-orange-light text-orange hover:bg-orange hover:text-white'
              }`}
            >
              <span className="mr-1">{category.icon}</span>
              {category.name}
            </Button>
          ))}
        </div>
      </div>

      {/* Providers Grid */}
      <div className="max-w-6xl mx-auto px-4 pb-6">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {filteredProviders.map((provider) => (
            <Card 
              key={provider.id} 
              className="overflow-hidden border-orange-light/30 hover:shadow-lg transition-shadow cursor-pointer"
              onClick={() => {
                setSelectedProvider(provider);
                setCurrentScreen('provider');
              }}
            >
              <div className="relative h-48">
                <ImageWithFallback
                  src={provider.image}
                  alt={provider.name}
                  className="w-full h-full object-cover"
                />
                <div className="absolute top-2 right-2">
                  <Badge className="bg-white text-orange">
                    <Star className="h-3 w-3 mr-1 fill-current" />
                    {provider.rating}
                  </Badge>
                </div>
              </div>
              <CardContent className="p-4">
                <div className="flex justify-between items-start mb-2">
                  <h3 className="font-bold text-lg">{provider.name}</h3>
                  <Badge variant="secondary" className="bg-yellow-light text-yellow-800">
                    {provider.deliveryTime}
                  </Badge>
                </div>
                <div className="flex items-center gap-4 text-sm text-muted-foreground mb-3">
                  <div className="flex items-center gap-1">
                    <MapPin className="h-3 w-3" />
                    {provider.location}
                  </div>
                  <div className="flex items-center gap-1">
                    <Star className="h-3 w-3" />
                    {provider.reviewCount} reseñas
                  </div>
                </div>
                <p className="text-sm text-muted-foreground mb-3">
                  {provider.services.length} servicios disponibles
                </p>
                <Button 
                  className="w-full bg-orange hover:bg-orange-light text-white"
                  onClick={(e) => {
                    e.stopPropagation();
                    setSelectedProvider(provider);
                    setCurrentScreen('provider');
                  }}
                >
                  Ver servicios
                </Button>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>
    </div>
  );

  const ProviderScreen = () => {
    if (!selectedProvider) return null;

    return (
      <div className="min-h-screen bg-white">
        {/* Header */}
        <div className="relative">
          <ImageWithFallback
            src={selectedProvider.image}
            alt={selectedProvider.name}
            className="w-full h-64 object-cover"
          />
          <Button
            variant="outline"
            size="sm"
            onClick={() => setCurrentScreen('home')}
            className="absolute top-4 left-4 bg-white/80 backdrop-blur-sm border-white"
          >
            <ArrowLeft className="h-4 w-4" />
          </Button>
          <Button
            variant="outline"
            size="sm"
            onClick={() => setCurrentScreen('cart')}
            className="absolute top-4 right-4 bg-white/80 backdrop-blur-sm border-white relative"
          >
            <ShoppingCart className="h-4 w-4" />
            {cart.length > 0 && (
              <Badge className="absolute -top-2 -right-2 h-5 w-5 p-0 bg-yellow text-xs">
                {cart.reduce((sum, item) => sum + item.quantity, 0)}
              </Badge>
            )}
          </Button>
        </div>

        {/* Provider Info */}
        <div className="max-w-6xl mx-auto px-4 py-6">
          <div className="mb-6">
            <h1 className="text-2xl font-bold mb-2">{selectedProvider.name}</h1>
            <div className="flex items-center gap-4 text-sm text-muted-foreground mb-3">
              <div className="flex items-center gap-1">
                <Star className="h-4 w-4 text-yellow fill-current" />
                {selectedProvider.rating} ({selectedProvider.reviewCount} reseñas)
              </div>
              <div className="flex items-center gap-1">
                <Clock className="h-4 w-4" />
                {selectedProvider.deliveryTime}
              </div>
            </div>
            <div className="flex items-center gap-1 text-sm text-muted-foreground">
              <MapPin className="h-4 w-4" />
              {selectedProvider.location}
            </div>
          </div>

          {/* Services Grid */}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            <h2 className="text-xl font-bold col-span-full mb-4">Servicios disponibles</h2>
            {selectedProvider.services.map((service) => (
              <Card key={service.id} className="overflow-hidden border-orange-light/30">
                <div className="relative h-32">
                  <ImageWithFallback
                    src={service.image}
                    alt={service.name}
                    className="w-full h-full object-cover"
                  />
                </div>
                <CardContent className="p-4">
                  <h3 className="font-bold mb-1">{service.name}</h3>
                  <p className="text-sm text-muted-foreground mb-2 line-clamp-2">{service.description}</p>
                  <div className="flex items-center justify-between mb-3">
                    <div>
                      <p className="font-bold text-orange">{formatPrice(service.price)}</p>
                      {service.duration && (
                        <p className="text-xs text-muted-foreground">{service.duration}</p>
                      )}
                    </div>
                  </div>
                  <Button
                    size="sm"
                    onClick={() => addToCart(service, selectedProvider)}
                    className="w-full bg-orange hover:bg-orange-light text-white"
                  >
                    <Plus className="h-4 w-4 mr-1" />
                    Agregar
                  </Button>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>
      </div>
    );
  };

  const CartScreen = () => (
    <div className="min-h-screen bg-white">
      {/* Header */}
      <div className="border-b border-orange-light/30 bg-white">
        <div className="max-w-6xl mx-auto px-4 py-4">
          <div className="flex items-center gap-3">
            <Button
              variant="ghost"
              size="sm"
              onClick={() => setCurrentScreen(selectedProvider ? 'provider' : 'home')}
            >
              <ArrowLeft className="h-4 w-4" />
            </Button>
            <h1 className="text-xl font-bold">Mi Carrito</h1>
          </div>
        </div>
      </div>

      <div className="max-w-4xl mx-auto px-4 py-6">
        {cart.length === 0 ? (
          <div className="text-center py-12">
            <ShoppingCart className="h-16 w-16 mx-auto text-orange mb-4" />
            <h2 className="text-xl font-bold mb-2">Tu carrito está vacío</h2>
            <p className="text-muted-foreground mb-4">Agrega servicios para organizar tu evento perfecto</p>
            <Button 
              onClick={() => setCurrentScreen('home')}
              className="bg-orange hover:bg-orange-light text-white"
            >
              Explorar servicios
            </Button>
          </div>
        ) : (
          <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
            {/* Cart Items */}
            <div className="lg:col-span-2 space-y-4">
              <h2 className="text-xl font-bold mb-4">Servicios seleccionados</h2>
              {cart.map((item) => (
                <Card key={`${item.id}-${item.providerId}`} className="border-orange-light/30">
                  <CardContent className="p-4">
                    <div className="flex items-start gap-3">
                      <ImageWithFallback
                        src={item.image}
                        alt={item.name}
                        className="w-20 h-20 object-cover rounded"
                      />
                      <div className="flex-1">
                        <h3 className="font-bold">{item.name}</h3>
                        <p className="text-sm text-muted-foreground mb-2">{item.providerName}</p>
                        <p className="text-sm text-muted-foreground mb-3">{item.description}</p>
                        <div className="flex items-center justify-between">
                          <p className="font-bold text-orange">{formatPrice(item.price)}</p>
                          <div className="flex items-center gap-2">
                            <Button
                              variant="outline"
                              size="sm"
                              onClick={() => updateCartQuantity(item.id, item.providerId, item.quantity - 1)}
                              className="h-8 w-8 p-0"
                            >
                              <Minus className="h-3 w-3" />
                            </Button>
                            <span className="mx-2 font-bold">{item.quantity}</span>
                            <Button
                              variant="outline"
                              size="sm"
                              onClick={() => updateCartQuantity(item.id, item.providerId, item.quantity + 1)}
                              className="h-8 w-8 p-0"
                            >
                              <Plus className="h-3 w-3" />
                            </Button>
                            <Button
                              variant="outline"
                              size="sm"
                              onClick={() => updateCartQuantity(item.id, item.providerId, 0)}
                              className="h-8 w-8 p-0 text-destructive hover:text-destructive ml-2"
                            >
                              <Trash2 className="h-3 w-3" />
                            </Button>
                          </div>
                        </div>
                      </div>
                    </div>
                  </CardContent>
                </Card>
              ))}
            </div>

            {/* Total and Checkout */}
            <div className="lg:col-span-1">
              <Card className="bg-orange-light/10 border-orange-light sticky top-4">
                <CardContent className="p-6">
                  <h3 className="font-bold text-lg mb-4">Resumen del pedido</h3>
                  <div className="space-y-2 mb-4">
                    {cart.map((item) => (
                      <div key={`${item.id}-${item.providerId}`} className="flex justify-between text-sm">
                        <span>{item.name} x{item.quantity}</span>
                        <span>{formatPrice(item.price * item.quantity)}</span>
                      </div>
                    ))}
                  </div>
                  <Separator className="my-4" />
                  <div className="flex justify-between items-center mb-6">
                    <span className="font-bold text-lg">Total:</span>
                    <span className="text-xl font-bold text-orange">{formatPrice(getCartTotal())}</span>
                  </div>
                  <Button 
                    className="w-full bg-orange hover:bg-orange-light text-white"
                    onClick={() => setCurrentScreen('auth')}
                  >
                    Continuar con el pedido
                  </Button>
                </CardContent>
              </Card>
            </div>
          </div>
        )}
      </div>
    </div>
  );

  const AuthScreen = () => {
    const [formData, setFormData] = useState({
      name: authUser?.name || '',
      address: authUser?.address || '',
      phone: authUser?.phone || '',
      email: authUser?.email || ''
    });

    const handleSubmit = (e: React.FormEvent) => {
      e.preventDefault();
      setUser(formData);
      setCurrentScreen('payment');
    };

    return (
      <div className="min-h-screen bg-white">
        {/* Header */}
        <div className="border-b border-orange-light/30 bg-white">
          <div className="max-w-6xl mx-auto px-4 py-4">
            <div className="flex items-center gap-3">
              <Button
                variant="ghost"
                size="sm"
                onClick={() => setCurrentScreen('cart')}
              >
                <ArrowLeft className="h-4 w-4" />
              </Button>
              <h1 className="text-xl font-bold">Información personal</h1>
            </div>
          </div>
        </div>

        <div className="max-w-2xl mx-auto px-4 py-6">
          <form onSubmit={handleSubmit} className="space-y-4">
            <div>
              <Label htmlFor="name">Nombre completo</Label>
              <Input
                id="name"
                value={formData.name}
                onChange={(e) => setFormData({...formData, name: e.target.value})}
                placeholder="Tu nombre completo"
                required
                className="border-orange-light/30 focus:border-orange"
              />
            </div>
            
            <div>
              <Label htmlFor="address">Dirección</Label>
              <Input
                id="address"
                value={formData.address}
                onChange={(e) => setFormData({...formData, address: e.target.value})}
                placeholder="Dirección del evento"
                required
                className="border-orange-light/30 focus:border-orange"
              />
            </div>
            
            <div>
              <Label htmlFor="phone">Teléfono</Label>
              <Input
                id="phone"
                type="tel"
                value={formData.phone}
                onChange={(e) => setFormData({...formData, phone: e.target.value})}
                placeholder="+56 9 1234 5678"
                required
                className="border-orange-light/30 focus:border-orange"
              />
            </div>
            
            <div>
              <Label htmlFor="email">Correo electrónico</Label>
              <Input
                id="email"
                type="email"
                value={formData.email}
                onChange={(e) => setFormData({...formData, email: e.target.value})}
                placeholder="tu@email.com"
                required
                className="border-orange-light/30 focus:border-orange"
              />
            </div>

            <Separator className="my-6" />

            <Button 
              type="submit" 
              className="w-full bg-orange hover:bg-orange-light text-white"
            >
              Continuar al pago
            </Button>
            
            <Button 
              type="button" 
              variant="outline" 
              className="w-full border-orange text-orange hover:bg-orange hover:text-white"
              onClick={() => {
                setUser({name: 'Invitado', address: '', phone: '', email: ''});
                setCurrentScreen('payment');
              }}
            >
              Continuar como invitado
            </Button>
          </form>
        </div>
      </div>
    );
  };

  const PaymentScreen = () => {
    const handlePayment = () => {
      setCurrentScreen('confirmation');
    };

    return (
      <div className="min-h-screen bg-white">
        {/* Header */}
        <div className="border-b border-orange-light/30 bg-white">
          <div className="max-w-6xl mx-auto px-4 py-4">
            <div className="flex items-center gap-3">
              <Button
                variant="ghost"
                size="sm"
                onClick={() => setCurrentScreen('auth')}
              >
                <ArrowLeft className="h-4 w-4" />
              </Button>
              <h1 className="text-xl font-bold">Método de pago</h1>
            </div>
          </div>
        </div>

        <div className="max-w-4xl mx-auto px-4 py-6">
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            {/* Order Summary */}
            <Card className="border-orange-light/30">
              <CardHeader>
                <CardTitle className="text-lg">Resumen del pedido</CardTitle>
              </CardHeader>
              <CardContent>
                <div className="space-y-2 mb-4">
                  {cart.map((item) => (
                    <div key={`${item.id}-${item.providerId}`} className="flex justify-between text-sm">
                      <span>{item.name} x{item.quantity}</span>
                      <span>{formatPrice(item.price * item.quantity)}</span>
                    </div>
                  ))}
                </div>
                <Separator />
                <div className="flex justify-between font-bold text-lg mt-4">
                  <span>Total:</span>
                  <span className="text-orange">{formatPrice(getCartTotal())}</span>
                </div>
              </CardContent>
            </Card>

            {/* Payment Methods */}
            <Card className="border-orange-light/30">
              <CardHeader>
                <CardTitle className="text-lg">Selecciona método de pago</CardTitle>
              </CardHeader>
              <CardContent>
                <RadioGroup value={paymentMethod} onValueChange={setPaymentMethod} className="space-y-3">
                  <div className="flex items-center space-x-2 p-3 border rounded border-orange-light/30">
                    <RadioGroupItem value="credit" id="credit" />
                    <Label htmlFor="credit" className="flex items-center gap-2 flex-1 cursor-pointer">
                      <CreditCard className="h-4 w-4" />
                      Tarjeta de crédito
                    </Label>
                  </div>
                  <div className="flex items-center space-x-2 p-3 border rounded border-orange-light/30">
                    <RadioGroupItem value="debit" id="debit" />
                    <Label htmlFor="debit" className="flex items-center gap-2 flex-1 cursor-pointer">
                      <CreditCard className="h-4 w-4" />
                      Tarjeta de débito
                    </Label>
                  </div>
                  <div className="flex items-center space-x-2 p-3 border rounded border-orange-light/30">
                    <RadioGroupItem value="cash" id="cash" />
                    <Label htmlFor="cash" className="flex items-center gap-2 flex-1 cursor-pointer">
                      <DollarSign className="h-4 w-4" />
                      Pago en efectivo
                    </Label>
                  </div>
                </RadioGroup>
                
                <Button 
                  onClick={handlePayment}
                  className="w-full mt-6 bg-orange hover:bg-orange-light text-white"
                >
                  Confirmar pedido
                </Button>
              </CardContent>
            </Card>
          </div>
        </div>
      </div>
    );
  };

  const ConfirmationScreen = () => {
    const orderNumber = Math.random().toString(36).substr(2, 9).toUpperCase();
    
    return (
      <div className="min-h-screen bg-white">
        <div className="max-w-4xl mx-auto px-4 py-12">
          <div className="text-center mb-8">
            <CheckCircle className="h-16 w-16 text-green-500 mx-auto mb-4" />
            <h1 className="text-2xl font-bold mb-2">¡Pedido confirmado!</h1>
            <p className="text-muted-foreground">Tu evento está siendo organizado</p>
          </div>

          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
            <Card className="border-orange-light/30">
              <CardHeader>
                <CardTitle className="text-lg">Detalles del pedido</CardTitle>
              </CardHeader>
              <CardContent>
                <div className="space-y-3">
                  <div className="flex justify-between">
                    <span>Número de pedido:</span>
                    <span className="font-bold">#{orderNumber}</span>
                  </div>
                  <div className="flex justify-between">
                    <span>Total pagado:</span>
                    <span className="font-bold text-orange">{formatPrice(getCartTotal())}</span>
                  </div>
                  <div className="flex justify-between">
                    <span>Método de pago:</span>
                    <span className="capitalize">
                      {paymentMethod === 'credit' ? 'Tarjeta de crédito' : 
                       paymentMethod === 'debit' ? 'Tarjeta de débito' : 'Efectivo'}
                    </span>
                  </div>
                  <div className="flex justify-between">
                    <span>Tiempo estimado:</span>
                    <span>2-3 días hábiles</span>
                  </div>
                </div>
              </CardContent>
            </Card>

            <Card className="border-orange-light/30">
              <CardHeader>
                <CardTitle className="text-lg">Información de contacto</CardTitle>
              </CardHeader>
              <CardContent>
                <div className="space-y-3">
                  <div className="flex items-center gap-2">
                    <User className="h-4 w-4 text-orange" />
                    <span>{user?.name || 'Invitado'}</span>
                  </div>
                  {user?.phone && (
                    <div className="flex items-center gap-2">
                      <Phone className="h-4 w-4 text-orange" />
                      <span>{user.phone}</span>
                    </div>
                  )}
                  {user?.email && (
                    <div className="flex items-center gap-2">
                      <Mail className="h-4 w-4 text-orange" />
                      <span>{user.email}</span>
                    </div>
                  )}
                </div>
              </CardContent>
            </Card>
          </div>

          <div className="flex justify-center gap-4">
            <Button 
              onClick={() => {
                setCart([]);
                setUser(null);
                if (authUser?.role === 'provider') {
                  setCurrentScreen('provider-dashboard');
                } else {
                  setCurrentScreen('home');
                }
              }}
              className="bg-orange hover:bg-orange-light text-white"
            >
              Volver al inicio
            </Button>
            <Button 
              variant="outline"
              className="border-orange text-orange hover:bg-orange hover:text-white"
            >
              Ver mi pedido
            </Button>
          </div>
        </div>
      </div>
    );
  };

  // Main render
  return (
    <div className="w-full bg-white min-h-screen">
      {currentScreen === 'loader' && <LoaderScreen />}
      {currentScreen === 'login' && <LoginScreen />}
      {currentScreen === 'register-customer' && <RegisterCustomerScreen />}
      {currentScreen === 'register-provider' && <RegisterProviderScreen />}
      {currentScreen === 'home' && <HomeScreen />}
      {currentScreen === 'provider' && <ProviderScreen />}
      {currentScreen === 'cart' && <CartScreen />}
      {currentScreen === 'auth' && <AuthScreen />}
      {currentScreen === 'payment' && <PaymentScreen />}
      {currentScreen === 'confirmation' && <ConfirmationScreen />}
      {currentScreen === 'provider-dashboard' && <ProviderDashboardScreen />}
      {currentScreen === 'add-service' && <AddServiceScreen />}
    </div>
  );
}