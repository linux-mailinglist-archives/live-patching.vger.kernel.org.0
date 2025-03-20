Return-Path: <live-patching+bounces-1314-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CC162A6AC89
	for <lists+live-patching@lfdr.de>; Thu, 20 Mar 2025 18:55:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AAC64487EF5
	for <lists+live-patching@lfdr.de>; Thu, 20 Mar 2025 17:54:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EAD3226161;
	Thu, 20 Mar 2025 17:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QUp8i5V0"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60C62628C;
	Thu, 20 Mar 2025 17:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742493285; cv=none; b=WjAEBpvR6mfytjHIqzBvZY8NuCyGnej/HplOo9toqMwwtni48HqrVm29cMHFhprG/25Ob447n5MMcavwbgVmnhKBhevJq9CEH3tyEflz+rx/ps2JhNcwjVoyU36Hnac/NYzhx7vRQyG3uugl8ftyq+/xQHgSI9cgKWEDgIS5KC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742493285; c=relaxed/simple;
	bh=4sxwANhWgnEl6Kc/mFjYhiXrRcRqIQfKJad6QWXOhDw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zb1hv5Pso6fbw0tszzh4uN7Ufnyxy+HI+srx7EXoayZ1c5fPDumS/V7/fdoxQhYtFDNNfD3qOepWtdqoSHnaoEzKMEwDPOqbEAzkHPjRngqTDTdq/o+bv3h20qpuCxL1oSE+e4xQeC/t/KAdgXoT61NkrDeUTNIjkZNwuICQz1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QUp8i5V0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50073C4CEEC;
	Thu, 20 Mar 2025 17:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742493284;
	bh=4sxwANhWgnEl6Kc/mFjYhiXrRcRqIQfKJad6QWXOhDw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=QUp8i5V0XxsaORfuEEn/a57KcDTV8a25rLGsUgHFZRFoIqgJJsWSCiPptlojBtmmZ
	 rCSdImJGPOMzjLbL56J2nU1YfCDQyK4GsVL+gHugqH+1u9PCu0gDF/sJCbAmKO53bE
	 ozIxLLkitm+tNbDG8bY+S6/LfYz09Ge0uBv0fTIkLaI1l4uPtFG/ybtQG3tm+nMmbp
	 v9dVQAY7Uhpou5IK3+bRTMnyd5AYxk71+S+8amCQicYjTHKxX0UhYnfjWOzAczTFMU
	 r5WxD0/HTgEM1Kr8oEPXWnF0PTp7Uxj7PU/B/Mdvimu5c+FKrJeL1y1U6aFzC9XP57
	 Rr7fnU8hNIA7g==
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3d3db3b68a7so11664545ab.0;
        Thu, 20 Mar 2025 10:54:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUOBpPjkpBUIjXQ3m9CPZeVW/4UBs7+yXOvZKXx+54tJaYWJmCarGJ+LMFHvDouy11d2o8uzx1h46CEonE=@vger.kernel.org, AJvYcCVUcn7qCg71PfaKjAuKEOs865wkqW6LQmGxHPIDY/xVSYayg+igIg6kk5CDQn+UvFcSoSmAQouqIs+qPUASI1a/zg==@vger.kernel.org, AJvYcCXgPbGk1Mbj3NfqGWEUWdsFPcf1RhhNPqZiP9acNaO5rKkxHFhyypBUbuFwOjlx7TBsIzG8XdBmKJlh0P7ZeQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzelCtGq4UNBhTHa8ViAmvEDUmTOZPTOS87d+X2U4sUTrI9hjCi
	sCsSLBVR8T7b8GFLoo4hNE3lxcDbf3/bJC+vMgeopUer1Q09SxGyswswKvMkFGlVOcUJH063utE
	GupLNVo5JCYvIdlZsigJbDbenoEg=
X-Google-Smtp-Source: AGHT+IFWP8pfbwBl1chUhyuT+CmtDXuqo+7XO1cRO0Tzq74gsrngMMCJZXVSqHKZk5dQh66q7nufSFKxHTUARVoFyIM=
X-Received: by 2002:a05:6e02:85:b0:3d0:4e0c:2c96 with SMTP id
 e9e14a558f8ab-3d5960d2337mr5568995ab.2.1742493283619; Thu, 20 Mar 2025
 10:54:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250320171559.3423224-2-song@kernel.org> <20250320174642.855602-1-wnliu@google.com>
In-Reply-To: <20250320174642.855602-1-wnliu@google.com>
From: Song Liu <song@kernel.org>
Date: Thu, 20 Mar 2025 10:54:32 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7RAXHRt3c+8DYqirPFRA+Sdw4ZNJ+Ad1uSiAHGOJ9RSA@mail.gmail.com>
X-Gm-Features: AQ5f1JqKgmhQkJ9V_QiMvwS8pM3CeUzcisCl2Y1OPuDskAkxbNElxRHFu-VgG9M
Message-ID: <CAPhsuW7RAXHRt3c+8DYqirPFRA+Sdw4ZNJ+Ad1uSiAHGOJ9RSA@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] arm64: Implement arch_stack_walk_reliable
To: Weinan Liu <wnliu@google.com>
Cc: indu.bhagat@oracle.com, irogers@google.com, joe.lawrence@redhat.com, 
	jpoimboe@kernel.org, kernel-team@meta.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-toolchains@vger.kernel.org, live-patching@vger.kernel.org, 
	mark.rutland@arm.com, peterz@infradead.org, puranjay@kernel.org, 
	roman.gushchin@linux.dev, rostedt@goodmis.org, will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 20, 2025 at 10:46=E2=80=AFAM Weinan Liu <wnliu@google.com> wrot=
e:
>
> On Thu, Mar 20, 2025 at 10:16=E2=80=AFAM Song Liu <song@kernel.org> wrote=
:
> >
> >  static __always_inline void
> > @@ -230,8 +231,26 @@ kunwind_next_frame_record(struct kunwind_state *st=
ate)
> >         new_fp =3D READ_ONCE(record->fp);
> >         new_pc =3D READ_ONCE(record->lr);
> >
> > -       if (!new_fp && !new_pc)
> > -               return kunwind_next_frame_record_meta(state);
> > +       if (!new_fp && !new_pc) {
> > +               int ret;
> > +
> > +               ret =3D kunwind_next_frame_record_meta(state);
>
> The exception case kunwind_next_regs_pc() will return 0 when unwind succe=
ss.
> Should we return a different value for the success case of kunwind_next_r=
egs_pc()?

I am assuming once the unwinder hits an exception boundary, the stack is no=
t
100% reliable. This does mean we will return -EINVAL for some reliable stac=
k
walk, but this is safer and good enough for livepatch. IIUC, SFrame based
unwinder should not have this limitation.

Thanks,
Song

>
> > +               if (ret < 0) {
> > +                       /*
> > +                        * This covers two different conditions:
> > +                        *  1. ret =3D=3D -ENOENT, unwinding is done.
> > +                        *  2. ret =3D=3D -EINVAL, unwinding hit error.
> > +                        */
> > +                       return ret;
> > +               }
> > +               /*
> > +                * Searching across exception boundaries. The stack is =
now
> > +                * unreliable.
> > +                */
> > +               if (state->end_on_unreliable)
> > +                       return -EINVAL;
> > +               return 0;
> > +       }
>

