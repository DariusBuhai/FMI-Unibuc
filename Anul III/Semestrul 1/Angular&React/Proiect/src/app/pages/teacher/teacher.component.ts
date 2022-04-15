import {Component, OnInit} from '@angular/core';
import {AngularFirestore} from "@angular/fire/compat/firestore";
import {ActivatedRoute} from "@angular/router";
import {Review} from "../../interfaces/review";
import {Teacher} from "../../interfaces/teacher";
import {AuthService} from "../../services/auth.service";

@Component({
    selector: 'app-teacher',
    templateUrl: './teacher.component.html',
    styleUrls: ['./teacher.component.scss']
})
export class TeacherComponent implements OnInit {
    public teacher: Teacher | undefined;
    public uid: string | null = null;
    public reviews: Review[] = [];
    private teacherId: string = '';
    private sub: any;
    public newReview: Review = {stars: 0, teacherId: '', comment: ''} as Review;

    constructor(private authService: AuthService, private db: AngularFirestore, private route: ActivatedRoute) {
    }

    async ngOnInit(): Promise<void> {
        this.uid = this.authService.uid;
        this.sub = this.route.params.subscribe(params => {
            this.teacherId = params['id'];
        });
        await this.initializeTeacher();
        await this.initializeReviews();
    }

    async initializeTeacher(): Promise<void> {
        const ref = this.db.doc<Teacher>(`teachers/${this.teacherId}`);
        let teacher = await ref.get().toPromise()
        this.teacher = teacher.data();
    }

    async initializeReviews(): Promise<void> {
        const ref = this.db.collection<Review>("reviews", ef => ef.where('teacherId', '==', this.teacherId));
        ref.valueChanges({idField: 'reviewId'}).subscribe((data: Review[]) => {
            this.reviews = (data as Review[]).sort((a: Review, b: Review) => {
                if ((a.date as Date) > (b.date as Date))
                    return 1;
                return -1;
            });
        })
    }

    updateReviewStars(stars: number) {
        if (stars == this.newReview.stars)
            stars = 0;
        this.newReview.stars = stars
    }

    async deleteReview(review: Review) {
        if (review.uId != this.uid) {
            alert("Cannot delete this review")
            return
        }
        await this.db.doc<Review>(`reviews/${review.reviewId}`).delete();
    }

    addReview() {
        if (this.newReview.comment.length < 10 || this.newReview.comment.length > 200) {
            alert("Introduceti intre 10 si 200 de caractere")
            return;
        }
        const ref = this.db.collection("reviews");
        this.newReview.teacherId = this.teacherId;
        if (this.uid != null) {
            this.newReview.uId = this.uid;
        }
        this.newReview.date = Date.now();
        ref.add(this.newReview).then(r => {
            this.newReview.comment = "";
            this.newReview.stars = 0;
        });
    }


}
