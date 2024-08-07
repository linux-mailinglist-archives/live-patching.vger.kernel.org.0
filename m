Return-Path: <live-patching+bounces-451-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0057994ACF4
	for <lists+live-patching@lfdr.de>; Wed,  7 Aug 2024 17:34:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A00411F230B7
	for <lists+live-patching@lfdr.de>; Wed,  7 Aug 2024 15:34:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3C2C12CDBA;
	Wed,  7 Aug 2024 15:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TeuRPo18"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2565B78C92
	for <live-patching@vger.kernel.org>; Wed,  7 Aug 2024 15:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723044829; cv=none; b=T0HQ7QJC7ykWuJo+vyrXlYN13gRBTuE6yO4UsiDBEh28vUOtyclB1MTSZ/xbOAkDoZpOoB3pDtSSu5cjfagbKnlV1hx/y7V+kD+PZ04C9b5L3HgvpUYf94MOlsjZZ92ym89xByg98NB6ydleJK3TnvmnKWQP5UFk87c8lQ7JUD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723044829; c=relaxed/simple;
	bh=GJJ6/4J63aPzip8F3qmZkagOt3HQBmrPhv3cmrweDFo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=At6RVLpF6/C+79InoyeW6YIE0VH4FF3ckuYE1UEvoz1iaGj3m5Ff2qxiaSTjKTVapk+NuiwgMqkYA4+1JxTw8b46sYOn5VLRD1OVjBFX1wzsaxAwIiRh2ecKS9JDacf4nN8prfHUbZ+inwkfpohyKD55UiQe+EgDA7bmYjaBQQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TeuRPo18; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-6bbbd25d216so5462966d6.0
        for <live-patching@vger.kernel.org>; Wed, 07 Aug 2024 08:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723044827; x=1723649627; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GJJ6/4J63aPzip8F3qmZkagOt3HQBmrPhv3cmrweDFo=;
        b=TeuRPo189UPeBJcfUFNEcChlYCN/U3x9Wp+dAlIMF2vbwR8JngjWPMCd+W7Ui9o16D
         brhjmBY3QqHIwc56WqnrsajMLAwhTj3FaRp4HaKZ5bbCcU5o0cUP5QBHRoXRV0zM+btU
         KMtC/H0SBlYn5y7nD5ejio1X5vezxuJYHamlz0UTQq9HZW8B7F4kAWpZGUu+JC1fgT30
         nlK6ilQTU1Us0W32pqXtdgEN1l+pgKf3O/1KXeAdPvQ7+wlPVYM0P5eKYYPila/QHZ2B
         nce9O30z0Bnh7UQgKRMFNAsW9Frgu4IYt2a/yZsh2KulBMYFWsX3o2oKEEQwR8iBi8dR
         NeVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723044827; x=1723649627;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GJJ6/4J63aPzip8F3qmZkagOt3HQBmrPhv3cmrweDFo=;
        b=EtWVFRj+U9XzoJMuwDxzLylmnp7LCUrUUUS0oHzHDxY7rVHO/FurjtpNsnAjJvViLJ
         f/0QxMJEmdAo0Zcow7ecqnZzwFfZBccMuOdZYXXHLD8xnMZ3Q664tTi3sSMgSBmdXqli
         SFHdunGQH1lz8bowkkrEUed1TmcB5BVLXDdVJUMaRW3bInDRM6PyChbTg+4I31QuJK46
         t1cYNvMXfgqMAYss7sgYZd5k87a7Xd1u/D98bPLi8csWHM684KiTk3GXIKI18qXPuxQF
         q5uMsUAIW3wSZUrMUI4Cjkc+hdGEoLh+l74biJa3pBgWRfxSDGrWFuLCCwizOfjdm6w/
         c8KA==
X-Forwarded-Encrypted: i=1; AJvYcCWUIMy7rz5MmZF+CwGeET5iUNOycQsgkDL1mivy3HJIKdq8ICcObJHCjtPxp9c67iu4tmqO7DWpTAbNoWNMENNw/7IfXbDJQy8uuvCfQg==
X-Gm-Message-State: AOJu0Yxub3b2/bml3f8djTR421RCapR5IlfzCME0RKLWBIAfexysrTQl
	Z63z8ESPop9K/ZZ7dTtjyuRNaaa0QKzDTCxcxzMwtz8dCYH4PorLVGbFNQ47Izq/fr8bpYdlxKK
	z2FzJfLdDmOpjkpch4fYbgFmHjhdFFdoU9R9X
X-Google-Smtp-Source: AGHT+IHvWa/Ytvp6xlpQo9w1vpfSyPNJKRWxay0t5bOW4D+l2HThaPS/mn8FuAJ+0xTb3yWOKivyVOA2NWpU5uN6aX8=
X-Received: by 2002:a0c:e6e3:0:b0:6b5:33c6:9caf with SMTP id
 6a1803df08f44-6bbbbdf4ae6mr44862646d6.16.1723044826883; Wed, 07 Aug 2024
 08:33:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240802210836.2210140-1-song@kernel.org> <20240802210836.2210140-4-song@kernel.org>
 <20240806144426.00ed349f@gandalf.local.home> <B53E6C7F-7FC4-4B4B-9F06-8D7F37B8E0EB@fb.com>
 <20240806160049.617500de@gandalf.local.home> <20240806160149.48606a0b@gandalf.local.home>
 <6F6AC75C-89F9-45C3-98FF-07AD73C38078@fb.com> <20240807090146.88b38c2fbd1cd8db683be22c@kernel.org>
 <BEEE3F89-717B-44A4-8571-68DA69408DA4@fb.com> <20240807190809.cd316e7f813400a209aae72a@kernel.org>
In-Reply-To: <20240807190809.cd316e7f813400a209aae72a@kernel.org>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Wed, 7 Aug 2024 08:33:07 -0700
Message-ID: <CABCJKucdMS1hkWjHWty8JyACjZy2R9juusABcbsMYzNej=pB2Q@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] tracing/kprobes: Use APIs that matches symbols
 without .XXX suffix
To: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Song Liu <songliubraving@meta.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Song Liu <song@kernel.org>, 
	"live-patching@vger.kernel.org" <live-patching@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Nathan Chancellor <nathan@kernel.org>, 
	"morbo@google.com" <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
	Luis Chamberlain <mcgrof@kernel.org>, Leizhen <thunder.leizhen@huawei.com>, 
	"kees@kernel.org" <kees@kernel.org>, Kernel Team <kernel-team@meta.com>, 
	Matthew Maurer <mmaurer@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Aug 7, 2024 at 3:08=E2=80=AFAM Masami Hiramatsu <mhiramat@kernel.or=
g> wrote:
>
> On Wed, 7 Aug 2024 00:19:20 +0000
> Song Liu <songliubraving@meta.com> wrote:
>
> > Do you mean we do not want patch 3/3, but would like to keep 1/3 and pa=
rt
> > of 2/3 (remove the _without_suffix APIs)? If this is the case, we are
> > undoing the change by Sami in [1], and thus may break some tracing tool=
s.
>
> What tracing tools may be broke and why?

This was a few years ago when we were first adding LTO support, but
the unexpected suffixes in tracing output broke systrace in Android,
presumably because the tools expected to find specific function names
without suffixes. I'm not sure if systrace would still be a problem
today, but other tools might still make assumptions about the function
name format. At the time, we decided to filter out the suffixes in all
user space visible output to avoid these issues.

> For this suffix problem, I would like to add another patch to allow probi=
ng on
> suffixed symbols. (It seems suffixed symbols are not available at this po=
int)
>
> The problem is that the suffixed symbols maybe a "part" of the original f=
unction,
> thus user has to carefully use it.
>
> >
> > Sami, could you please share your thoughts on this?
>
> Sami, I would like to know what problem you have on kprobes.

The reports we received back then were about registering kprobes for
static functions, which obviously failed if the compiler added a
suffix to the function name. This was more of a problem with ThinLTO
and Clang CFI at the time because the compiler used to rename _all_
static functions, but one can obviously run into the same issue with
just LTO.

Sami

