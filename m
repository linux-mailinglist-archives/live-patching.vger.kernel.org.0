Return-Path: <live-patching+bounces-1870-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 8ADE9C6C8EF
	for <lists+live-patching@lfdr.de>; Wed, 19 Nov 2025 04:20:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E24683469B1
	for <lists+live-patching@lfdr.de>; Wed, 19 Nov 2025 03:17:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13D4B2E7BC3;
	Wed, 19 Nov 2025 03:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HbV/ZTkZ"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4140081724
	for <live-patching@vger.kernel.org>; Wed, 19 Nov 2025 03:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763522261; cv=none; b=CxruOAZj/DqtFZxMva3Wu+Ym79v93MoY/eqV63BqMW7j8E0t/6Zd2JJdi2oZ3fQegy7rAkvOZsTknuVhzNmNBYjsSd+GkRn8ctStEXHuVYO+DrPJi9YVS209ycqqXcTy+JW6ZCfkzCn0OrRrY7tLX8yIJPV94NXunVERDzRX8+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763522261; c=relaxed/simple;
	bh=bGE2FSWhnm+BsuCwfqkgjyvZT97Awr0SpQfjamE3tzg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q5Qk9E1ugxqlsUPGrsSIyeAPC0Q3pRns0yjLJvtXLLtkv4XPAAdvKsBBMx0XHPiYqDLpqV4ByOgvPNWDwp+y/1bdA6XJF5mucruP4sezEguaomqKSxar6G/1OoJ9utnQ55WSbXANP5GrE191l8nF+DDfZ24/bYu2o8SM/QBMdLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HbV/ZTkZ; arc=none smtp.client-ip=209.85.217.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-5dbd1421182so5053783137.1
        for <live-patching@vger.kernel.org>; Tue, 18 Nov 2025 19:17:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763522258; x=1764127058; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YFMQm8c43T8cW98Fil9ZjV+GElfkAR2WejoEfPbtfmg=;
        b=HbV/ZTkZCAc0KUATYLS8GuBQmfNgiooxTrW5M/UR9arwKRHDjkqf6+GHWZIF4MB/DM
         8dMYwmu4EJdGHMf5V5MG3HvzgRjiUbuA1Iltwg7Z3N05FG0lmVvCUtLo9Dj/+K0W7x4z
         RrgVSH8G95ci4MuGc+NGU8Eo5Q4cKfZ62ZqLUFOsJ/8rmEp9wE/S8xbwC3FmvuBg5BdB
         d9B/zHydKgPatVy7PIkPqsv3Y0fR39RVtDs1yrmMWfEA+bXfWxTJF7UprVc6mGOfoD+b
         OUS6Pxqgz1CK0laURLA0dLwKFHgU8LJhsXs68MexAIrtoX28TkSgtfoIAYBZG8n4stvC
         lypw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763522258; x=1764127058;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YFMQm8c43T8cW98Fil9ZjV+GElfkAR2WejoEfPbtfmg=;
        b=WpqtEdtWTlPz1MOTGCPpkLMkgji7S/Z7aSRQAJk50rbEpPHUT+cljysR7BY9ZCHa3E
         dmmJG7Dae4qSJDWlF0OTZhZvE5rdfheG75RKZ322nN6UB1RPvv5wjkoXouhIkOC00phf
         aVfjvtJp4AW5QcEP7TvflAvg6vbP+nzVjeN8SmJM3F2akUKxIiAu7LuJ/9yHFFGIQnzV
         sWMPEyYUjRZxr65Z12RM1ph3J8HNca3XYHYeDXG2wpLZfD01cdJ+xFUZ5LbykKZr4lVH
         +Qp04Xt+ONKYdSPo3VXGr0VQxoVIRSn2UamsQsmAw1NiC0dtOJoGB+pa0JlMIKHInsat
         cJpw==
X-Forwarded-Encrypted: i=1; AJvYcCX9sGEc0nTQkQ2d0ZnqXxVBofT67h4Sq/XIC+/StPQHECH4BeI1nVHAzCxosEI2eIynE1J/a6Q8+c7NqFBv@vger.kernel.org
X-Gm-Message-State: AOJu0YxP2ydsjb+/0vcv6IEkdLxbil48FVU2/ovuVb0vAX9YvgUYmvUU
	KcmnOr/N0eqv3Npi7Oxe5vEDZoNBn8GcW0sK6yAeQChdhitj+OGgmxp1lm1f5S2SqNYH3dq2dst
	aGGCjJgHnXVFfzOobF6Xu4gLhw0B4APmAD3muCmrh
X-Gm-Gg: ASbGncu+4YPuQhwPH/5DUd2XJpLuLzucE98fbocepb8LRPYDeVrQZYRdEn5CORF8Mwr
	RBqopL+3I5eRWokPHYk2LbqaHAysiGNdUDlRWlJYpcpBc1vh39mHdAs69RgyckDPk4VrHZGHXwV
	Z45jxkdOhBqZnLN6hWKy9RtOxmjvgIbY3hwr1zKWXqYQDFPjqYxJbS+D9AjCylkTr9B2tGgAVA5
	CJ+JsVm17o72Ad5xVDQHJxhtDUt+KDh3HVjaI3bTy2gTGKtDDR41hJUKuf5+PNlUGFTpG8dTuNY
	CUuJZXzNnjX6+QTFDbC8e+Dt0Q==
X-Google-Smtp-Source: AGHT+IGuHt6QVYkArljAj+sXurP+fdZk4N+jE835bO6a/P663kob6GV48UoxLx+gKuXLZE1nw77J5rWySIx14mNoOZI=
X-Received: by 2002:a05:6102:3e1f:b0:5dd:b287:e5f4 with SMTP id
 ada2fe7eead31-5dfc5313ab9mr7301020137.0.1763522257914; Tue, 18 Nov 2025
 19:17:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250904223850.884188-1-dylanbhatch@google.com>
 <20250904223850.884188-7-dylanbhatch@google.com> <xo2ro446awhsd7i55shx6tlz6s2azuown4xk6zfm7ie4zz2nqc@244onpurkvy3>
 <CADBMgpyVis+fRHLOv6BRPrT+0r8846MOutkmOgMbqytLVXh9Ag@mail.gmail.com> <eo5fod6csuininieur2lm6bxunmpbk6n3wtxajamrwqqpae3ja@o3eqwfp3u6su>
In-Reply-To: <eo5fod6csuininieur2lm6bxunmpbk6n3wtxajamrwqqpae3ja@o3eqwfp3u6su>
From: Dylan Hatch <dylanbhatch@google.com>
Date: Tue, 18 Nov 2025 19:17:26 -0800
X-Gm-Features: AWmQ_bk-0xhw1SySqNiy4aXx_xfdfZXZ2-k0DzbEw2CLkyF0R4EiCs_WzlizEss
Message-ID: <CADBMgpzmzyQgs4K3XoYf5h=C7vv-FDfNb5wharucyeoxUKo4bg@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] unwind: arm64: Add reliable stacktrace with sframe unwinder.
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Indu Bhagat <indu.bhagat@oracle.com>, 
	Peter Zijlstra <peterz@infradead.org>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Jiri Kosina <jikos@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>, 
	Mark Rutland <mark.rutland@arm.com>, Ian Rogers <irogers@google.com>, 
	linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, joe.lawrence@redhat.com, 
	Puranjay Mohan <puranjay@kernel.org>, Song Liu <song@kernel.org>, 
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 17, 2025 at 3:01=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> On Fri, Nov 14, 2025 at 10:44:20PM -0800, Dylan Hatch wrote:
> > Sorry for the slow reply on this, I'm going to try and get a v3 out
> > sometime after next week.
> >
> > On Wed, Sep 17, 2025 at 4:41=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel=
.org> wrote:
> > >
> > > As far I can tell, the *only* error condition being checked is if it
> > > (successfully) fell back to frame pointers.
> >
> > By checking/handling error conditions, do you mean just marking the
> > state as unreliable in any case where the unwind isn't successful with
> > SFrame?
>
> Right, any sframe error it encounters along the way (including missing
> sframe) would be a reason to mark it as unreliable.
>
> > I'm thinking if I can make the unwind_next_frame_sframe() code
> > path handle the end of the stack correctly on its own, I can more
> > strictly mark the trace as unreliable if it encounters any error.
> >
> > >
> > > What if there was some bad or missing sframe data?  Or some unexpecte=
d
> > > condition on the stack?
> > >
> > > Also, does the exception handling code have correct cfi/sframe metada=
ta?
> > >
> > > In order for it to be "reliable", we need to know the unwind reached =
the
> > > end of the stack (e.g., the task pt_regs frame, from entry-from-user)=
.
> >
> > It looks like the frame-pointer based method of handling the end of
> > the stack involves calling kunwind_next_frame_record_meta() to extract
> > and check frame_record_meta::type for FRAME_META_TYPE_FINAL. I think
> > this currently assumes (based on the definition of 'struct
> > frame_record') that the next FP and PC are right next to each other,
> > alongside the meta type. But the sframe format stores separate entries
> > for the FP and RA offsets, which makes extracting the meta type from
> > this information a little bit murky to me.
> >
> > Would it make sense to fall back to the frame pointer method for the
> > final stack frame? Or I guess I could define a new sframe-friendly
> > meta frame record format?
>
> For sframe v3, I believe Indu is planning to add support for marking the
> outermost frame.  That would be one definitive way to know that the
> stack trace made it to the end.

How would this work? Is there a way of determining at compile time
which functions would end up being the outermost frame?

>
> Or, if the entry-from-user pt_regs frame is always stored at a certain
> offset compared to the end of the task stack page, that might be another
> way.

It looks like kunwind_next_frame_record_meta() uses this strategy
already. It checks that 'fp =3D=3D &task_pt_regs(tsk)->stackframe' to
validate that it has in fact reached the end of the stack. It seems
like we need alternate versions of kunwind_next_frame_record_meta()
and kunwind_next_regs_pc() that use the CFA calculated from the sframe
data (instead of the frame pointer). Does that sound right?

Thanks,
Dylan

On Mon, Nov 17, 2025 at 3:01=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> On Fri, Nov 14, 2025 at 10:44:20PM -0800, Dylan Hatch wrote:
> > Sorry for the slow reply on this, I'm going to try and get a v3 out
> > sometime after next week.
> >
> > On Wed, Sep 17, 2025 at 4:41=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel=
.org> wrote:
> > >
> > > As far I can tell, the *only* error condition being checked is if it
> > > (successfully) fell back to frame pointers.
> >
> > By checking/handling error conditions, do you mean just marking the
> > state as unreliable in any case where the unwind isn't successful with
> > SFrame?
>
> Right, any sframe error it encounters along the way (including missing
> sframe) would be a reason to mark it as unreliable.
>
> > I'm thinking if I can make the unwind_next_frame_sframe() code
> > path handle the end of the stack correctly on its own, I can more
> > strictly mark the trace as unreliable if it encounters any error.
> >
> > >
> > > What if there was some bad or missing sframe data?  Or some unexpecte=
d
> > > condition on the stack?
> > >
> > > Also, does the exception handling code have correct cfi/sframe metada=
ta?
> > >
> > > In order for it to be "reliable", we need to know the unwind reached =
the
> > > end of the stack (e.g., the task pt_regs frame, from entry-from-user)=
.
> >
> > It looks like the frame-pointer based method of handling the end of
> > the stack involves calling kunwind_next_frame_record_meta() to extract
> > and check frame_record_meta::type for FRAME_META_TYPE_FINAL. I think
> > this currently assumes (based on the definition of 'struct
> > frame_record') that the next FP and PC are right next to each other,
> > alongside the meta type. But the sframe format stores separate entries
> > for the FP and RA offsets, which makes extracting the meta type from
> > this information a little bit murky to me.
> >
> > Would it make sense to fall back to the frame pointer method for the
> > final stack frame? Or I guess I could define a new sframe-friendly
> > meta frame record format?
>
> For sframe v3, I believe Indu is planning to add support for marking the
> outermost frame.  That would be one definitive way to know that the
> stack trace made it to the end.
>
> Or, if the entry-from-user pt_regs frame is always stored at a certain
> offset compared to the end of the task stack page, that might be another
> way.
>
> --
> Josh

