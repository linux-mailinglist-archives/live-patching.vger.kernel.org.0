Return-Path: <live-patching+bounces-1102-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC37EA24CBE
	for <lists+live-patching@lfdr.de>; Sun,  2 Feb 2025 07:37:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC0E53A5B2C
	for <lists+live-patching@lfdr.de>; Sun,  2 Feb 2025 06:37:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD1181D416B;
	Sun,  2 Feb 2025 06:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qpMJ1YJv"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318FE1A270
	for <live-patching@vger.kernel.org>; Sun,  2 Feb 2025 06:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738478269; cv=none; b=H1Qae2mnq9TRezvj2JFzCuoes92ghOljzgb3iXCMsC0esXwEjuToJx4Lx3mcnT+WOE55mKQsOATciX41s1Fl3P0YWFBtQsO8HfM2IxIHtGq0z8i68DREPcGe8VG31gP1oPtrpmY3epvBTE+earJ5VIgCQ8B+QyRqpBipVMmAmgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738478269; c=relaxed/simple;
	bh=ZE141DfKW7Je97SuGuDXiTvEfzvyFvIIlvmWSKHBrSU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tIG4UIuC6MUmhBrIZclOmNif1xYkkG/6Th2sXYYlwVvd1GNtAOi9KCXp7VItITIRZhjlkQtP2KzT+mPmDn7tx4gW75xcrG9iNgiL11CXuU1UFagkQ7xhQwttNHP6XP9iYvy2SlCYU83AJvv9gSL5Fh4x07Nhopzk1hoXy+BbhGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qpMJ1YJv; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2163d9a730aso69666455ad.1
        for <live-patching@vger.kernel.org>; Sat, 01 Feb 2025 22:37:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738478267; x=1739083067; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A9NvLmW/A6uUOB760Lj7I76Wak9fBpOpnPabjMwc01o=;
        b=qpMJ1YJvon2WPQJvkL1C2zLjBBKyp2zsPqOxqshF/mI2309D7CIhzanHZ9qjd3DNmy
         G/VYsb9ssLGLa8ObnnTIcAdkScD3g/FMfze36UM88KS4qnQ1HiWZTuPxh0XwCM4b4JFo
         hW2I/+kQzGtNdSOERNkg8pFB7zGWNTEBJJvZt+kgPFcszD1NmddllT4mjcIvxJvFg3Gy
         CBJUw1M5rd1pd7uCscKRxaDjsjEm4rBicQSG87bjAWZlSje5/rfmFIhVGvmBgbQyFoUw
         k+9Q7ycjlrjQeBlPQL2g6ZIdwQBK4PG3JskI2SNun91xq1toBucbHUrCP42j46AtZ4LY
         kGpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738478267; x=1739083067;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=A9NvLmW/A6uUOB760Lj7I76Wak9fBpOpnPabjMwc01o=;
        b=sUny9CAezExqCYDgu1UKkp6jErjrhdJTCMe8V+qCGxzAU3xlxlj88JjN3gz1RD/ZKG
         hV6skfqNR0l25U//L97gafP26vKHip6ls4x3+Q2SXOsZRy1FcL4BNPMV9EGxHeqJvsrv
         kkh83VLoylepSZMcaic8R/TOVzMkLxSG2OjzpN0weTAA3GXReeOS3xarvh1uMfbjZE6W
         nMz+PLB96vLzNbJtq8NtT4lzIK0WRPhpPBbFhK5damH7oOOrCB2R3BE5btCYGv/gGvpA
         +as96hGuOy+/cHmaY91sRUoL/oPwETnwLkRl+F9Xq6Bqp9q1MHQCQ3znr6O0WjbJA8j0
         6AfQ==
X-Forwarded-Encrypted: i=1; AJvYcCUXV14Kj6RC7Va599oiE6W7jsnx+F7kXSgfxgz0vpE8SIrJklPjcwvB9b16kgwMk7FfZq0AfBMk5ECej3cK@vger.kernel.org
X-Gm-Message-State: AOJu0YxIThNmNg1pQAazj/LJPsKQ0i3q28hnowFhsvv7cJvYgCZ15Lvq
	zLLCJsSefPD/OEyUc5kejzQpfPbMsN+3s2M9VMZuLxAzdGnfJx8jaq2CH1mAT5ceR+Yd4N5k9g=
	=
X-Google-Smtp-Source: AGHT+IEViwf7ftDA47jzjJ4JIFfkYBeziUL/Uim6LKs1f/dyvgToTVzbkfLeuhfa6q0+31njXbcGNfqpzQ==
X-Received: from pguy8.prod.google.com ([2002:a65:6c08:0:b0:8ae:4cf4:372])
 (user=wnliu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:240c:b0:21a:87e8:3891
 with SMTP id d9443c01a7336-21edd7eba4fmr152671605ad.6.1738478267463; Sat, 01
 Feb 2025 22:37:47 -0800 (PST)
Date: Sun,  2 Feb 2025 06:37:44 +0000
In-Reply-To: <20250202062728.753686-1-wnliu@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250202062728.753686-1-wnliu@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250202063746.759828-1-wnliu@google.com>
Subject: Re: [PATCH 4/8] unwind: Implement generic sframe unwinder library
From: Weinan Liu <wnliu@google.com>
To: wnliu@google.com
Cc: indu.bhagat@oracle.com, irogers@google.com, joe.lawrence@redhat.com, 
	jpoimboe@kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-toolchains@vger.kernel.org, 
	live-patching@vger.kernel.org, mark.rutland@arm.com, peterz@infradead.org, 
	ptsm@linux.microsoft.com, roman.gushchin@linux.dev, rostedt@goodmis.org, 
	will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 30, 2025 at 2:29=E2=80=AFAM Prasanna Kumar T S M <ptsm@linux.mi=
crosoft.com> wrote:
> On 30-01-2025 15:52, Prasanna Kumar T S M wrote:
> >
> > On 28-01-2025 03:03, Weinan Liu wrote:
> > > This change introduces a kernel space unwinder using sframe table for
> > > architectures without ORC unwinder support.
> > >
> > > The implementation is adapted from Josh's userspace sframe unwinder
> > > proposal[1] according to the sframe v2 spec[2].
> > >
> > > [1]
> > > https://lore.kernel.org/lkml/42c0a99236af65c09c8182e260af7bcf5aa1e158=
.1730150953.git.jpoimboe@kernel.org/
> > > [2] https://sourceware.org/binutils/docs/sframe-spec.html
> > >
> > > Signed-off-by: Weinan Liu <wnliu@google.com>
> > > ---
> > >   include/linux/sframe_lookup.h |  43 ++++++++
> > >   kernel/Makefile               |   1 +
> > >   kernel/sframe_lookup.c        | 196 +++++++++++++++++++++++++++++++=
+++
> Nit: Can this file be placed inside lib/ instead of kernel/ folder?
This could be integrated with Josh's proposal in the future.
https://lore.kernel.org/lkml/cover.1737511963.git.jpoimboe@kernel.org/

Either lib/ or kernel/unwind/ are ok to me.

