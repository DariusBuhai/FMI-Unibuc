import { Component, OnInit } from '@angular/core';
import { AuthService } from 'src/app/services/auth.service';
import {AngularFirestore, AngularFirestoreCollection, AngularFirestoreDocument} from "@angular/fire/compat/firestore";
import {Teacher} from "../../interfaces/teacher";
import {Router} from "@angular/router";
import {Review} from "../../interfaces/review";

@Component({
  selector: 'app-index',
  templateUrl: './index.component.html',
  styleUrls: ['./index.component.scss'],
})
export class IndexComponent implements OnInit {
  public classNames: string = 'btn btn-primary';
  public loadedPage: boolean = false;
  public teachers: Teacher[] = [];
  public allGroups: string[] = [];
  public groupFilter: string | null = null;
  constructor(private authService: AuthService, private router: Router, private db: AngularFirestore) {}

  async ngOnInit(): Promise<void> {
    if(!this.authService.isLoggedIn)
      await this.router.navigate(['/login'])
    await this.initializeTeachers();
    this.loadedPage = true;
  }

  async initializeTeachers() {
    const refTeachers: AngularFirestoreCollection<Teacher> = this.db.collection<Teacher>("teachers");
    refTeachers.valueChanges({idField: 'teacherId'}).subscribe((teachers)=>{
      this.teachers = [];
      this.allGroups = [];
      teachers.forEach((teacher)=>{
        if(!this.allGroups.includes(teacher.group))
          this.allGroups.push(teacher.group)
        const ref = this.db.collection<Review>("reviews", ef => ef.where('teacherId', '==', teacher.teacherId));
        ref.valueChanges().subscribe((data: Review[])=>{
          let reviews = (data as Review[]);
          teacher.reviews = reviews.length;
          teacher.stars = 0;
          reviews.forEach((review)=>{
            teacher.stars += review.stars;
          })
          teacher.stars = Math.round(teacher.stars/teacher.reviews)
        })
        this.teachers.push(teacher)
      })
    })
  }

  applyTeachersSeriesFilter(groupFilter: string | null){
    this.groupFilter = groupFilter;
  }
}
