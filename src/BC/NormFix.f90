!----------------------------------------------------------------------------------------------------------------------------------
! SPHERA (Smoothed Particle Hydrodynamics research software; mesh-less Computational Fluid Dynamics code).
! Copyright 2005-2015 (RSE SpA -formerly ERSE SpA, formerly CESI RICERCA, formerly CESI-; SPHERA has been authored for RSE SpA by 
!    Andrea Amicarelli, Antonio Di Monaco, Sauro Manenti, Elia Bon, Daria Gatti, Giordano Agate, Stefano Falappi, 
!    Barbara Flamini, Roberto Guandalini, David Zuccalà).
! Main numerical developments of SPHERA: 
!    Amicarelli et al. (2015,CAF), Amicarelli et al. (2013,IJNME), Manenti et al. (2012,JHE), Di Monaco et al. (2011,EACFM). 
! Email contact: andrea.amicarelli@rse-web.it

! This file is part of SPHERA.
! SPHERA is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
! SPHERA is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
! GNU General Public License for more details.
! You should have received a copy of the GNU General Public License
! along with SPHERA. If not, see <http://www.gnu.org/licenses/>.
!----------------------------------------------------------------------------------------------------------------------------------

!----------------------------------------------------------------------------------------------------------------------------------
! Program unit: NormFix
! Description: 
!----------------------------------------------------------------------------------------------------------------------------------

subroutine NormFix
!------------------------
! Modules
!------------------------ 
use Static_allocation_module
use Hybrid_allocation_module
use Dynamic_allocation_module
!------------------------
! Declarations
!------------------------
implicit none
integer(4) :: npi
double precision :: unity
double precision,dimension(3) :: appo
!------------------------
! Explicit interfaces
!------------------------
!------------------------
! Allocations
!------------------------
!------------------------
! Initializations
!------------------------
!------------------------
! Statements
!------------------------
if (Ncord==2) then
!$omp parallel do default(none) private(npi,appo,unity) shared(nag,Pg)
   do npi=1,nag
      if ((pg(npi)%cella==0).or.(pg(npi)%vel_type=="std")) cycle
      call InterFix(npi,appo,unity)
! Components of the generic normal  
      pg(npi)%mno = Dsqrt((appo(1)*appo(1)) + (appo(3)*appo(3)))
      pg(npi)%zer(1) = appo(1) / (pg(npi)%mno + 0.0001d0)
      pg(npi)%zer(2) = zero
      pg(npi)%zer(3) = appo(2) / (pg(npi)%mno + 0.0001d0)
      pg(npi)%ang = (ATAN2(pg(npi)%zer(1),pg(npi)%zer(3)))
      if ((abs(pg(npi)%zer(1))<0.5).AND.(abs(pg(npi)%zer(3))<0.5)) then
         pg(npi)%zer(1) = zero
         pg(npi)%zer(2) = zero
         pg(npi)%zer(3) = zero
         pg(npi)%mno    = zero
         pg(npi)%ang    = zero
      end if
   end do
!$omp end parallel do
   else if (Ncord==3) then
!$omp parallel do default(none) private(npi,appo,unity) shared(nag,Pg)
   do npi=1,nag
      if ((pg(npi)%cella==0).or.(pg(npi)%vel_type=="std")) cycle
      call InterFix(npi,appo,unity)
      pg(npi)%mno = Dsqrt((appo(1) * appo(1)) + (appo(2) * appo(2)) + (appo(3) &
                    * appo(3)))
      pg(npi)%zer(:) = appo(:) / (pg(npi)%mno + 0.0001d0)
   end do
!$omp end parallel do
end if
!------------------------
! Deallocations
!------------------------
return
end subroutine NormFix
