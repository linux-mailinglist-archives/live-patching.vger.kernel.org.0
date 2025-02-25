Return-Path: <live-patching+bounces-1229-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D061A450C6
	for <lists+live-patching@lfdr.de>; Wed, 26 Feb 2025 00:01:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 76CB4177618
	for <lists+live-patching@lfdr.de>; Tue, 25 Feb 2025 23:01:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54B3A233727;
	Tue, 25 Feb 2025 23:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UErkwsfL"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D0B1A5BBB
	for <live-patching@vger.kernel.org>; Tue, 25 Feb 2025 23:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740524501; cv=none; b=UQnacmYI64wxqukO9hUFABdMeBJv8RxVZFPpaEc7G85x/sDr23W/qwwGU3J/6DNM9trHG19IFqAE8Jg07p60RdWdhC05YHb/Fv34xFSkJCixc/Gq6Fe5vyzQK/1NZf6FH5G8NjpA2umHAx5B6NxGbWrMLbrB418+vBSewM55PZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740524501; c=relaxed/simple;
	bh=mde08ePw0U7qTCok3XXW6MXXh6mFRApsatbSp7N27VA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iLgB9jeS0Vgqbj3FkB3SZ04R6LFMZyQjJA6y+6e0NE44NWz8obYmiPO0sXri0i3hi7Jaf9WJYLXZr5i5aEY+fsK+hsq9TLKKw8bHVgx82kWWqWWya9GMreZVqMnvF4nQQhybmrGmpLeA7gpCLdD6U5VLHLoaSsMRJlvx2j89CeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UErkwsfL; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc5888c192so11900160a91.0
        for <live-patching@vger.kernel.org>; Tue, 25 Feb 2025 15:01:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740524499; x=1741129299; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mde08ePw0U7qTCok3XXW6MXXh6mFRApsatbSp7N27VA=;
        b=UErkwsfLWJtZQ/OBS3pnMRXGxuXO7eaRKOU1paJ93DxIwz5nBu4qaZuIGsAHJ1bwHX
         pt19UTTHdEBzBk/QtWSDKRGM8gUovuuUHlrg2XfvHNuGjJnVrBrwHhEIf5MD6UvCmKkg
         B7S8HGkfSQHoO2Vud5y5y/Cw3GYShrkmbwExhsfZsjEZVRQP3XLBvell0btQencjUYNA
         RwgSx7nd2tRSfvQS0xY48Lt1QLMco4Z0HNl3q4nqe2IcU0QZYD93n+EkcjvYCZ69bHgq
         qhvE9DH28ZuN6q2ylY9qi+vha7VoiUun4pUSUNNicKcyjAIAa5saUDPlxBUkbuPbn5TZ
         hgIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740524499; x=1741129299;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mde08ePw0U7qTCok3XXW6MXXh6mFRApsatbSp7N27VA=;
        b=iGxme78AxOhHIA3a9kY4GzsX779RDl1eMrd7fbHfqHo3/Vx+c9S2DDTSvHmz54fggp
         0lQYTLNwzFqKO5uMJ1TTb5f2wWsa4ZBQtMZlLI1EzYOHxn5bOmLkAKKaAz+yEe2v8UIY
         SPwMkbQEqR7M6cnoYcM0R2aE17VzIYXPPNPO9HcRSwj6doD2Z6lNIadHG8K912wVpu20
         5QjRroRldK3MLO5LA4BiT35MbnyDF2gpHonToiWWgInEuXieDcLIFDql5O5eBMykWv1h
         MuSRZUt6nMAAQgsdEbaW+888JuZe09vhgcIjwE0ct2WD0oOqa2l8KXGOOyZJWs7SYzry
         SDEA==
X-Forwarded-Encrypted: i=1; AJvYcCXYwpESmioEKOvgpiwykpmuuPkzsQVawHzOCGLcXKKbLZcTAgzntrnoO/eSgE3Waf2tDB0hDRZsQvXiWVfV@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4g+YwArEsiAUqOU5Zu/ulW7EV31hfdEyG+yBSilAYi4gxvHI8
	v05xszlLTjkcQxd/iT5dDeu851AM6TJSfG2DHjEqg3wcf4gsGOd4QLH8LQ60+cRiyMCiO79m3Q=
	=
X-Google-Smtp-Source: AGHT+IHPhKxQsRjLLUmrOJuKKmq+fpePmjEEOBM1vx7AS8VefdM5jfSQyDCFPrR8FFoSvuoQhhkXY0nLEw==
X-Received: from pjbsd6.prod.google.com ([2002:a17:90b:5146:b0:2f2:ea3f:34c3])
 (user=wnliu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:da87:b0:2f6:539:3cd8
 with SMTP id 98e67ed59e1d1-2fe7e33c7afmr2054308a91.18.1740524499118; Tue, 25
 Feb 2025 15:01:39 -0800 (PST)
Date: Tue, 25 Feb 2025 23:01:36 +0000
In-Reply-To: <20250225181331.frmfumf4b5ctfbsm@jpoimboe>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250225181331.frmfumf4b5ctfbsm@jpoimboe>
X-Mailer: git-send-email 2.48.1.658.g4767266eb4-goog
Message-ID: <20250225230137.620606-1-wnliu@google.com>
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
From: Weinan Liu <wnliu@google.com>
To: jpoimboe@kernel.org
Cc: indu.bhagat@oracle.com, irogers@google.com, joe.lawrence@redhat.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-toolchains@vger.kernel.org, live-patching@vger.kernel.org, 
	mark.rutland@arm.com, peterz@infradead.org, puranjay@kernel.org, 
	roman.gushchin@linux.dev, rostedt@goodmis.org, will@kernel.org, 
	wnliu@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 25, 2025 at 10:13=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.or=
g> wrote:
>
> On Tue, Feb 25, 2025 at 01:02:24AM +0000, Weinan Liu wrote:
> > On Mon, Feb 10, 2025 at 12:30=E2=80=AFAM Weinan Liu <wnliu@google.com> =
wrote:
> > > I already have a WIP patch to add sframe support to the kernel module=
.
> > > However, it is not yet working. I had trouble unwinding frames for th=
e
> > > kernel module using the current algorithm.
> > >
> > > Indu has likely identified the issue and will be addressing it from t=
he
> > > toolchain side.
> > >
> > > https://sourceware.org/bugzilla/show_bug.cgi?id=3D32666
> >
> >
> > I have a working in progress patch that adds sframe support for kernel
> > module.
> > https://github.com/heuza/linux/tree/sframe_unwinder.rfc
> >
> > According to the sframe table values I got during runtime testing, look=
s
> > like the offsets are not correct .
> >
> > When unwind symbols init_module(0xffff80007b155048) from the kernel
> > module(livepatch-sample.ko), the start_address of the FDE entries in th=
e
> > sframe table of the kernel modules appear incorrect.
> > For instance, the first FDE's start_addr is reported as -20564. Adding
> > this offset to the module's sframe section address (0xffff80007b15a040)
> > yields 0xffff80007b154fec, which is not within the livepatch-sample.ko
> > memory region(It should be larger than 0xffff80007b155000).
>
> I assume kpatch create-diff-object needs to copy over a subset of the
> .sframe section. =C2=A0Similar to what kpatch_regenerate_orc_sections() d=
oes.


You're right that we need to process the sframe section like what
kpatch_regenerate_orc_sections() does when building livepatch by kpatch.

However, livepatch-sample.ko is not generated by kpatch.=C2=A0It is built
directly from samples/livepatch/livepatch-sample.c by gcc during the kernel
build


