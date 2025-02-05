Return-Path: <live-patching+bounces-1115-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3BD9A285B5
	for <lists+live-patching@lfdr.de>; Wed,  5 Feb 2025 09:39:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7DCD1166D00
	for <lists+live-patching@lfdr.de>; Wed,  5 Feb 2025 08:39:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 743DC22A1E4;
	Wed,  5 Feb 2025 08:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E4xUKpqP"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B296022A1CA
	for <live-patching@vger.kernel.org>; Wed,  5 Feb 2025 08:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738744790; cv=none; b=dIlL3SGebFYyC8k8KTZY6mFmAe8rTuBMNppjw+GZjA+qSDPyIBs9jsM0TwCwBnC+oSF9GsaXErJQJ6g6R8LlvzMU8rzI9fRvoZVRbxwUGEGXcme4lWXeabqWCRl93IA+1DvtJr1Vvd+7jSJIMCW+nn4BwtxPWVQAHxIO6eEI2Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738744790; c=relaxed/simple;
	bh=ELuwu9IsV/dlyqDtXLMsIf6DCckoJ2XUTaeidbo6rFk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oSg1vQRFm+RO0LEeE92zP3OJ/asH72P5AjVRsRMSKRf9Mb3gkLoZocZ/6L87m9/XNCNSXRW7KHYVlV/wbK9Xio5mgHH1iTkb0lSzCGY5aswwhWdaIGVRQYFbD1rdO0O6vIrQJn4T8i/B9tlGMPcm6STtQ7mNZ+AyBLnFFXAAqHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E4xUKpqP; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-6e43557fd94so786016d6.0
        for <live-patching@vger.kernel.org>; Wed, 05 Feb 2025 00:39:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738744787; x=1739349587; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jlw3NFYPM888VYE/ezAJsCvJT6IWK4dzJxKARk77hTY=;
        b=E4xUKpqP6JsuDNlJIVPPFNtnP8DNyQKi9j2nV4tck8LpXn0zG25hAApoRkmYFcDiCQ
         mS3pB2m6C/aXgbWPpfm+tnGLxOnCN2qjTPNqQFQ5d6zEJMVQJnvLk+PdBAsdtkR1jVSg
         WpdVyqquNCwqHAUhQ3e0oxFiRkKtG3NIWxSot4dIdRRnnFEWlsLd4w9U0kyjq1t8Ee7r
         tNk1lYSqOoYEd5EjXHygMBXnp6kOVvRvfeLRdJ7QHwhoLBehtoVu/5IbnjqFg8BW++5/
         PUX7Xj6qaHSQaREhjQcI/7ItTmFYStcF36cjTku7lvpWXfp8MO1ZBjrUf5gkg+XVymhC
         75iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738744787; x=1739349587;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jlw3NFYPM888VYE/ezAJsCvJT6IWK4dzJxKARk77hTY=;
        b=eYmqs6C1kWlOR0bl6J3OHVd2PjdTg2P2DHaT/0jCfQ9wvhZSTzFnjvPGBuXl39ijjN
         u1BpK6QUOYu18CUzbjoriuKl1p0/A4vgQLXsF/v5NkyhLASmijqJgD7jevNM8t4Bg0Ko
         ELuwfm9iG7LO616Ei5t+5UqP0Roxwupyea184/L62nZ3Z2f08oo8iVFBpqfPQmfFqLQV
         5UNnmFGka8ZExZrLDG660YDz54WtmlmjBpuLGNKr9kpP1wY62mabEectAePNhiKHhWKN
         YOCezvXXceKHsSBQA13O4qw4BpSGmmq3MKtGJjPFBn7aKb2HVG8nsNEKH7fK+lN2WJ5u
         9wDg==
X-Forwarded-Encrypted: i=1; AJvYcCUAhF0t/gwVqIY9Z0lxjlbxKRo08O5yR3NHTtcHwPZJPgZSHiZUFuDKJT4CB0XqisogjPvH2onCIzKc3AKi@vger.kernel.org
X-Gm-Message-State: AOJu0YwN2Pj0BBGjqvO+6vfG6f9PxUMKm5rq5EFtWXNzyEtzEiZVaS16
	rsB3KMoDG3R4H1GwWTZ4QyL5MqJgskGJfgzxxb0hPNGsoNMjKatAnRSNMApo4EIUGO4dZHEp6m5
	Wu6MtSfdd0v+1L1O8Vz3Y7F0WEHQ=
X-Gm-Gg: ASbGnct/RoTBzxi3JcfJuDHkBF3ji9ciZBSGJKy1zAR9a+S0sLJ1R6c91ypuO+Ha/TP
	9i83ykUyGK7SFvq9yQWyrIgo/lA+NtQiDRIzNh+kcBkN1IUdEqZON8scEyyPFy6KYZxX5oQ7+jw
	==
X-Google-Smtp-Source: AGHT+IEOUlvQbhdjiIufMJakvg9fXRRL+h4DyHucI9HK3UdgQs0uAkv88FUknrY7vQzL1/LVALmbOpcM99angj4WJ5A=
X-Received: by 2002:ad4:5993:0:b0:6d8:f612:e27d with SMTP id
 6a1803df08f44-6e42fc1c30dmr24647956d6.32.1738744787391; Wed, 05 Feb 2025
 00:39:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250122085146.41553-1-laoar.shao@gmail.com> <Z5DpqC7sm5qCJFtj@pathway.suse.cz>
 <A250B752-FFBF-4A53-B981-FE6D9A9F5C14@gmail.com> <Z5zSmlRIv5qhuVja@pathway.suse.cz>
In-Reply-To: <Z5zSmlRIv5qhuVja@pathway.suse.cz>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 5 Feb 2025 16:39:11 +0800
X-Gm-Features: AWEUYZk7sJEQSrUQ7t1bhI9585Yog4rQYUXgZ6GineP4b9XGI-UiLTpHE2LJ6kM
Message-ID: <CALOAHbCjZFKS9enXhNF60uYckKT+LJcRJGYq4xU+RxawJm+eMw@mail.gmail.com>
Subject: Re: [PATCH] livepatch: Avoid hard lockup caused by klp_try_switch_task()
To: Petr Mladek <pmladek@suse.com>
Cc: zhang warden <zhangwarden@gmail.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Jiri Kosina <jikos@kernel.org>, mbenes@suse.cz, joe.lawrence@redhat.com, 
	live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 31, 2025 at 9:39=E2=80=AFPM Petr Mladek <pmladek@suse.com> wrot=
e:
>
> On Fri 2025-01-31 21:22:13, zhang warden wrote:
> >
> >
> > > On Jan 22, 2025, at 20:50, Petr Mladek <pmladek@suse.com> wrote:
> > >
> > > With this patch, any operation which takes the tasklist_lock might
> > > break klp_try_complete_transition(). I am afraid that this might
> > > block the transition for a long time on huge systems with some
> > > specific loads.
> > >
> > > And the problem is caused by a printk() added just for debugging.
> > > I wonder if you even use a slow serial port.
> > >
> > > You might try to use printk_deferred() instead. Also you might need
> > > to disable interrupts around the read_lock()/read_unlock() to
> > > make sure that the console handling will be deferred after
> > > the tasklist_lock gets released.
> > >
> > > Anyway, I am against this patch.
> > >
> > > Best Regards,
> > > Petr
> >
> > Hi, Petr.
> >
> > I am unfamiliar with the function `rwlock_is_contended`, but it seems t=
his function will not block and just only check the status of the rw_lock.
> >
> > If I understand it right, the problem would raise from the `break` whic=
h will stop the process of `for_each_process_thread`, right?
>
> You got it right. I am afraid that it might create a livelock
> situation for the livepatch transition. I mean that the check
> might almost always break on systems with thousands of processes
> and frequently created/exited processes. It always has
> to start from the beginning.

It doesn=E2=80=99t start from the beginning, as tasks that have already
switched over will be skipped.

Since the task->patch_state is set before the task is added to the
task list and the child=E2=80=99s patch_state is inherited from the parent,=
 I
believe we can remove the tasklist_lock and use RCU instead, as
follows:

diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index 30187b1d8275..1d022f983bbc 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -399,11 +399,11 @@ void klp_try_complete_transition(void)
         * Usually this will transition most (or all) of the tasks on a sys=
tem
         * unless the patch includes changes to a very common function.
         */
-       read_lock(&tasklist_lock);
+       read_rcu_lock();
        for_each_process_thread(g, task)
                if (!klp_try_switch_task(task))
                        complete =3D false;
-       read_unlock(&tasklist_lock);
+       read_rcu_unlock();

        /*
         * Ditto for the idle "swapper" tasks.


--
Regards
Yafang

