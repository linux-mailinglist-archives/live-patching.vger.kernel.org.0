Return-Path: <live-patching+bounces-1170-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E2BEA33797
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 06:54:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F187167B51
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 05:54:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B453C206F3E;
	Thu, 13 Feb 2025 05:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LYUTBNOl"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15FA2063D1
	for <live-patching@vger.kernel.org>; Thu, 13 Feb 2025 05:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739426071; cv=none; b=qI4hpY8qt2hcUilosky0O08SJXemoZ+JIYBpEJcdgNpd9FMHTeqA0AzRNlY2WvYm57mMMjRi4kWhjq/1Brx1CGnkKU7xyk8ZdX4/Z5KnwLsKjBF1VnZel3pmzV4dEeyQx1RALWH5nPPy87Z6qkMzlmchkKYVqdcRkPY/TVls04A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739426071; c=relaxed/simple;
	bh=vG7Put1/nIu5Yx0qCHeIwL+rcbmTyCt1OmCHm0H56b8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=msFRy9BK46gTefi+W+UUadfjCTSSFG+siiHUAyCKG9et8bHATKuUQrwlcWCFIST+z/KXwMicHaljgtncuAj3VMN48ZeGjOSyC8clanrcbW8a+vzq5kG/G73F1L6rnuNRympbMP9slDT6+GTJY6g2Qw/HUXS9CfFJ1B1CRKvnNC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LYUTBNOl; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-6e454a513a6so4740006d6.3
        for <live-patching@vger.kernel.org>; Wed, 12 Feb 2025 21:54:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739426069; x=1740030869; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gVNC5UubF+CMFfORuOPfZD32CY5Lol6r8CZvTAQ2Uts=;
        b=LYUTBNOldx4c0aukB7TRaWJwtMYwdvemMerFPmm1BDihwcG63quztU79SXzMeoZCRJ
         N5aCUpljrZQgFm89dO6OSN6Elmdd+2JW3P0Rb8AQ/edJMRQYRQuRx2jQf0a7wy85LuaX
         AB+ZQZB7vqxfHGCAsH6UKeCIY43VZWN4vtThvjgkMH39F4vc0ngJYaPTq4Zx4p6OeFE5
         0ahogKS/un8Qzef+OE/x+OzyXNXPJ/vMmCkazNE5UrAqRsxa48XV5V1eXa4bhljPFv7t
         oc43YWkINcHuS/kuJdihtzNhdIuss5PyE644mmjDzz7q7tBYqiCKDhYBPi74otxOZvOy
         LSdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739426069; x=1740030869;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gVNC5UubF+CMFfORuOPfZD32CY5Lol6r8CZvTAQ2Uts=;
        b=eEUG6QfiRrRn1Q+i8wIpHjeP8vPgo7ejO0URr9ut2TklUSRKFRRLMt1lD0dySANe3M
         uyLneeZ9lLcqi3vTbAjpHdaCaMbicXBso13O4qYRcLsphSe0i7H+zFVtVCWnfNBpJyei
         s2omiLMtUfCy2r+o7re+UYJTY0iRY8aHhiYFFjgRuw1WbUUeQDh1gZ/2kwxKNdPjrJVu
         JKtqre4lVoYNOMI8x5yCfnmd39EugW8B5a6zCJCveiaDYHDj4c8epAEy1nSnD216Vi6K
         jYxU6ZjEnAGkKRRZXMIrp5fgxdPbZGpnj4Eg+RcSy5MreTQf5fWBqMnNBQZv3N3jfpMw
         jMRw==
X-Forwarded-Encrypted: i=1; AJvYcCWJBTWaiKiLNElV/80mE8Ij9Qycky3mMBan4DI1undyT5qkqEEi8hq7phkKppVXTxXUINskNJq6vCASJpYF@vger.kernel.org
X-Gm-Message-State: AOJu0YzZ00RLDoxjYjEsJGl+yfCDvC2fqdrQCzZvquRwU1yp6Qb7enI/
	eHKzPWhtOAu59mbS0+1rsnXBmSWpgWZkSj8Tx+fnH2+nNFPhbPmn8seeBEdzG7GIZTkIJoZ/pbm
	F4h0Ek+AOFiXnyF4yfPXethR5QNY=
X-Gm-Gg: ASbGnct471a9Kw/jL3o1B6GuLYKqbfXbzFVkZtSNX+Zy3GpW3YCHvqYp2m5sUPfm4xp
	5h7AxxWscMkAQZhoSD0eEEnrr2zVENfZH4QsSPy6uA/KejXCQFhGKVgzEPJqWbN/7JqJu/VarNJ
	U=
X-Google-Smtp-Source: AGHT+IFdzEp6RsAkxnTtyityzkgVAFMb49zutM+C2yBwkgglkGhrU4RTSvXk0Q9aYD12tlcqX1FqRSNdSlgFQydt1fI=
X-Received: by 2002:a05:6214:c2e:b0:6e4:3478:b55a with SMTP id
 6a1803df08f44-6e46edacf8bmr95677246d6.35.1739426068786; Wed, 12 Feb 2025
 21:54:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250211062437.46811-1-laoar.shao@gmail.com> <20250211062437.46811-3-laoar.shao@gmail.com>
 <20250212004009.ijs4bdbn6h55p7xd@jpoimboe> <CALOAHbDsSsMzuOaHX2ZzgD3bJTPgMEp1E_S=vERHaTV11KrVJQ@mail.gmail.com>
 <CALOAHbDEBqZyDvSSv+KTFVR3owkjfawCQ-fT9pC1fMHNGPnG+g@mail.gmail.com>
 <Z6zBb9GRkFC-R0RE@pathway.suse.cz> <20250213013603.i6uxtjvc3qxlsqwc@jpoimboe>
In-Reply-To: <20250213013603.i6uxtjvc3qxlsqwc@jpoimboe>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Thu, 13 Feb 2025 13:53:52 +0800
X-Gm-Features: AWEUYZkdw5RRiCAOJYvz-tVUftgu-eNd1r2jRlzueIvfPC8TnMEowsoBUIVSi4M
Message-ID: <CALOAHbD=5GzZt7Vczzie2CXxLavZgpwkj34o9EV1JdCE8ZoAgg@mail.gmail.com>
Subject: Re: [PATCH 2/3] livepatch: Avoid blocking tasklist_lock too long
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>, jikos@kernel.org, mbenes@suse.cz, 
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 13, 2025 at 9:36=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> On Wed, Feb 12, 2025 at 04:42:39PM +0100, Petr Mladek wrote:
> > CPU1                          CPU1
> >
> >                               klp_try_complete_transition()
> >
> >
> > taskA:
> >  + fork()
> >    + klp_copy_process()
> >       child->patch_state =3D KLP_PATCH_UNPATCHED
> >
> >                                 klp_try_switch_task(taskA)
> >                                   // safe
> >
> >                               child->patch_state =3D KLP_PATCH_PATCHED
> >
> >                               all processes patched
> >
> >                               klp_finish_transition()
> >
> >
> >       list_add_tail_rcu(&p->thread_node,
> >                         &p->signal->thread_head);
> >
> >
> > BANG: The forked task has KLP_PATCH_UNPATCHED so that
> >       klp_ftrace_handler() will redirect it to the old code.
> >
> >       But CPU1 thinks that all tasks are migrated and is going
> >       to finish the transition
>
>
> Maybe klp_try_complete_transition() could iterate the tasks in two
> passes?  The first pass would use rcu_read_lock().  Then if all tasks
> appear to be patched, try again with tasklist_lock.

This option is much simpler, easier to understand, and more
maintainable. I prefer this approach.

>
> Or, we could do something completely different.  There's no need for
> klp_copy_process() to copy the parent's state: a newly forked task can
> be patched immediately because it has no stack.
>
> So instead, just initialize it to KLP_TRANSITION_IDLE with
> TIF_PATCH_PENDING cleared.  Then when klp_ftrace_handler() encounters a
> KLP_TRANSITION_IDLE task, it considers its state to be 'klp_target_state'=
.
>
> // called from copy_process()
> void klp_init_task(struct task_struct *child)
> {
>         /* klp_ftrace_handler() will transition the task immediately */
>         child->patch_state =3D KLP_TRANSITION_IDLE;
>         clear_tsk_thread_flag(child, TIF_PATCH_PENDING);
> }
>
>
> klp_ftrace_handler():
>
>                 patch_state =3D current->patch_state;
>
>                 if (patch_state =3D=3D KLP_TRANSITION_IDLE)
>                         patch_state =3D klp_target_state;
>                 ...
>
> Hm?


--=20
Regards
Yafang

