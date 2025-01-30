Return-Path: <live-patching+bounces-1092-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 43DBEA233CB
	for <lists+live-patching@lfdr.de>; Thu, 30 Jan 2025 19:34:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C0018188524E
	for <lists+live-patching@lfdr.de>; Thu, 30 Jan 2025 18:34:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A96761922D4;
	Thu, 30 Jan 2025 18:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tZUzzL1j"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77465143888;
	Thu, 30 Jan 2025 18:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738262061; cv=none; b=LgX5VzHjM3NJg0AZQFiQFWKX8YxsH8xgqZVmXqpl8EEU+8fskH+Kt3vtulz4wZDTxW2qkrk6p72R93LJlXU38ZNCp+7mjl7vCWn8Zuj4xSkhFX4KUKb4xgKv04NHr0wxsnM+6Fwtk2/nnUK4JJFfWgFpnHsamewqNGRSFUpuelY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738262061; c=relaxed/simple;
	bh=emEvaD0snb1I+KoYe1hZsB1kdYm9ngN1ujNXHazy8iA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WECjk1YpNbHrKSJWHr3n6MSog1QO5CIaIJ3McPtn/86cIy1rPrNbpU39taeywiehSHg6yXimXVdi1xDIovL/kObExYmDXGNB7GUrDL0z9vTKNmhgd5HijBo+hJwtBeWwEhqOG32qWD+RMNsb7uGCa7tz4FDHpvVEQpTNAlNuHgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tZUzzL1j; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAFD1C4CED3;
	Thu, 30 Jan 2025 18:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738262060;
	bh=emEvaD0snb1I+KoYe1hZsB1kdYm9ngN1ujNXHazy8iA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=tZUzzL1jUp1E7FGpQagx8FdojhUGQyuEH6KOAsfR/mG//dLbRGgHQDZn8nN1qFBWd
	 URoVjGklO8ilwqgoGnyKGox3b5I3d4J4k90f56jkBEwlgko1IRVZn2Wf05s0wa+SiJ
	 VCJ8p7Z7k+KLMBmeHA5rnow100NREGlxsO7cKw9Fhc1MvGy4GLO8tLtfJc9Ts8sJ3x
	 YOQZ/7tq3HyS5P/9q2ch0uVmhujpif2mKFBo84Qylvq4QuNUQXx3fZR7peCrv04z7Q
	 0yTut/NE1tzsh6zIjfK4fA78VjSWXWA7PCz4FHim4VNy4MCSL8sXLw8YS+N0KTlwva
	 sPtWfywdYqBhQ==
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3ce87d31480so3918135ab.2;
        Thu, 30 Jan 2025 10:34:20 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVyCcd8dPYjqo2+X6NV6NQoE7MrtJyyIUi6Ol6BD8/tR+/RkiQ7A+RC7pnHWTcCmynAifWM/iWV27oLJmvIeAupww==@vger.kernel.org, AJvYcCX8fQGXbirh1ztmv7t1Tpz252bAKmnOGI1sOW5IswHgWsvPtCoUEa4VOBDIVuBnuA6yrXmkqhgNanVzI7c=@vger.kernel.org, AJvYcCXxL8555TiHk4rKBjzI9SusUbC27nrjcAfqa+2ZPeWxB8A/UEhSPt/e7nLPv/y0zgyDITNp26zWg0FTVHwBiw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxIKsctJGnEqGCG2FvReufhdqEnd8f3ex/+LkY6Gfux4eG5tqQJ
	0dEhlFaaQBGSfrdH5YHAHolT8KGVxtoeeuV8MdKfUsiqEkzYvrFJ2LDsHfjc8aMTI3dqokgKcoX
	OQOGoT2AO0V6eoW3NORDEWnMEA+o=
X-Google-Smtp-Source: AGHT+IHl4N25m7zqeEajPKatIGe0RodI8SLfJYlOUjqTeDPQzguZ3bn4VqrsIlE3PttoRvEJMKnh0jCIKWwufPy29H4=
X-Received: by 2002:a05:6e02:20e2:b0:3cf:fe1f:f5c5 with SMTP id
 e9e14a558f8ab-3cffe423925mr70175235ab.9.1738262060209; Thu, 30 Jan 2025
 10:34:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250127213310.2496133-1-wnliu@google.com> <CAPhsuW4UrhaYKj6pbAC9Cq1ZW+igFrA284nnCFsVdKdOfRpi6w@mail.gmail.com>
In-Reply-To: <CAPhsuW4UrhaYKj6pbAC9Cq1ZW+igFrA284nnCFsVdKdOfRpi6w@mail.gmail.com>
From: Song Liu <song@kernel.org>
Date: Thu, 30 Jan 2025 10:34:09 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7f5--hzr0Y3eb1JNpfNqepJuE92yq3y8dzaL_mQF+U5w@mail.gmail.com>
X-Gm-Features: AWEUYZmxfzPagOrcjlEC0Ts_lMB8rPrmxz6AOan_ZzpkJ7g-5LcRVOD6FqJcZw4
Message-ID: <CAPhsuW7f5--hzr0Y3eb1JNpfNqepJuE92yq3y8dzaL_mQF+U5w@mail.gmail.com>
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
To: Weinan Liu <wnliu@google.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Indu Bhagat <indu.bhagat@oracle.com>, Peter Zijlstra <peterz@infradead.org>, 
	Mark Rutland <mark.rutland@arm.com>, roman.gushchin@linux.dev, 
	Will Deacon <will@kernel.org>, Ian Rogers <irogers@google.com>, linux-toolchains@vger.kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	joe.lawrence@redhat.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 30, 2025 at 9:59=E2=80=AFAM Song Liu <song@kernel.org> wrote:
>
> I missed this set before sending my RFC set. If this set works well, we
> won't need the other set. I will give this one a try.

I just realized that llvm doesn't support sframe yet. So we (Meta) still
need some sframe-less approach before llvm supports sframe.

IIRC, Google also uses llvm to compile the kernel. Weinan, would
you mind share your thoughts on how we can adopt this before
llvm supports sframe? (compile arm64 kernel with gcc?)

Thanks,
Song

