Return-Path: <live-patching+bounces-475-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3BE594CA63
	for <lists+live-patching@lfdr.de>; Fri,  9 Aug 2024 08:20:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B435283B79
	for <lists+live-patching@lfdr.de>; Fri,  9 Aug 2024 06:20:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 575C316D303;
	Fri,  9 Aug 2024 06:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CyGYLiua"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA2D16C6B0;
	Fri,  9 Aug 2024 06:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723184454; cv=none; b=bMLbSRMLanrM9JNmVsWrkEsWPBZ0AQq8EWTqoA5XgCiPyVUMNpchVsnFLZsigHQn9l6KT3ZF5p1F0eK/gSLgaHeDvfrN826aKtAibE+MbkWJxSLJtzMOU0qgOYhN5DIMEPNwAAw0elmHeXc/F2UNTgLtbTo5nXEmtzaVBt1tTXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723184454; c=relaxed/simple;
	bh=aA11aefebB4utmXirba0ehrdoaznzBhD9HVwhEzt0Js=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HUszUX0Vjx0q2UDphkfDLsCjRuGH6uU4ePwCGeORurxlAJ22eQYt/h7/XHP/sFrNlAtvF+yOtXk1sFwqYNYEpOYW3UrSMxQ7yDlG2QxS+y6zk5bQjvQW7VJwO5pSUVhT7a11TDrGnDoigHiaIRrLhFj8EsTZCLavM5KB8km/Nmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CyGYLiua; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-260fed6c380so1172181fac.1;
        Thu, 08 Aug 2024 23:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723184452; x=1723789252; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aA11aefebB4utmXirba0ehrdoaznzBhD9HVwhEzt0Js=;
        b=CyGYLiuaM1qYcT7AzPkICy3RlDDFs+BRtygCsPorqv+RREwDTWKlXclvr3RJ8ECbEX
         KAt88Z+B6G4ZYXbzTYzGs3TW2Rzm6hrTjycLVW2PHs6Jnj4Xx5j8gw7lAvwKmmaDym49
         Mt5R6XHw3GNI9wHklpXG2//IyGrDCI3mdn4JornYDalUy3MteSqCrD3JH9I7GejX4+yo
         NPLKWVxidX1r2kPO0sS1B0exdbwzOQ08GX7PfnrJu8KHV5mlpUtDkdq/ptka3kKHIsNn
         8YUl06KlpAbWaBuLdLvgaaSRSoKwGbqzkwWfNaQWnrtFNE+4qAbxL44ObESLQ82vXV9Z
         4fgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723184452; x=1723789252;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aA11aefebB4utmXirba0ehrdoaznzBhD9HVwhEzt0Js=;
        b=hV0ZW0gvAZhyRGEC+8EDutkQ0R102A6D9cU4bnivz/RYkvsCFn7hHoZPNcXyPNdYWv
         yCGcKXS8UosmUNLhe/0OFLOzhwt1ir5kVUiXlcv0JHGX5LuwLEBuFArgOBqyjXGwOaNs
         6XgePe/px36HoojWZi0wqh/RBYpCvPl/3CjouOOSleg4oDYvkByACJHrMf8nRZfoSTxZ
         Mc0R5qn0c8VCShw4KOwUpG1+LXTCaNXFj23njSefkk4Snmbm3gjmqpkqOqnkebTNRUXT
         2AZGOFQbWsFvIq8Ie263u0v/U8B45sZpuiwmDylhk8XBTOSGeqUl2eoOLr6hTERqNIv3
         nblw==
X-Forwarded-Encrypted: i=1; AJvYcCU+5Y/KrdQs4pCGzZclWf1HoCPwn3DCsLz0K2sf4QSTO/D2lAEQyxfihKtJHgzSdRQmdyR8O1TIxYh+JBJaIqwDP3SRazwwydiymPHvjBztXo8WisO15nsm3Brw3y5Y0bjGeLuWL2vIUVGxkr+ormwXUk8as9DfydV/NOpgDM/26XOHYRAXGqFZkOBWv0yc/w==
X-Gm-Message-State: AOJu0YyQP0iiVwTd+Mj9rl0iasKsY51WB0cwqFMJ+fqRJTmGIqawR7/D
	0Net4lalCQBRTi1Xz0L0eWYbQ7nqEILsd7zbDRP5fMliM7uW/JTVO2dbF1e0lDp12c3gBOZ3Nm2
	6sbsCkWW0GfoAMnCI0KeGg0Ocjl0=
X-Google-Smtp-Source: AGHT+IERl9zszuKHpdxDLyBONioVd83Ghs//vh0vz6AsfGDCLL5VPWLygNQb5UlKj78iwLdmDEqGOYhU/ZPjWH4ShcM=
X-Received: by 2002:a05:6870:f112:b0:261:65f:ca5e with SMTP id
 586e51a60fabf-26c62c184a2mr852005fac.8.1723184451636; Thu, 08 Aug 2024
 23:20:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240806144426.00ed349f@gandalf.local.home> <B53E6C7F-7FC4-4B4B-9F06-8D7F37B8E0EB@fb.com>
 <20240806160049.617500de@gandalf.local.home> <20240806160149.48606a0b@gandalf.local.home>
 <6F6AC75C-89F9-45C3-98FF-07AD73C38078@fb.com> <20240807090146.88b38c2fbd1cd8db683be22c@kernel.org>
 <BEEE3F89-717B-44A4-8571-68DA69408DA4@fb.com> <20240807190809.cd316e7f813400a209aae72a@kernel.org>
 <CABCJKucdMS1hkWjHWty8JyACjZy2R9juusABcbsMYzNej=pB2Q@mail.gmail.com>
 <09ED7762-A464-45FF-9062-9560C59F304E@fb.com> <ZrSW5KgFMjlB1Rn2@pathway.suse.cz>
In-Reply-To: <ZrSW5KgFMjlB1Rn2@pathway.suse.cz>
From: Alessandro Carminati <alessandro.carminati@gmail.com>
Date: Fri, 9 Aug 2024 08:20:15 +0200
Message-ID: <CAPp5cGRZZxxxMez4B5dqjQCD6307K==5-aTLfqDmZu2Ui9mEmQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] tracing/kprobes: Use APIs that matches symbols
 without .XXX suffix
To: Petr Mladek <pmladek@suse.com>
Cc: Song Liu <songliubraving@meta.com>, Sami Tolvanen <samitolvanen@google.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Song Liu <song@kernel.org>, 
	"live-patching@vger.kernel.org" <live-patching@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Nathan Chancellor <nathan@kernel.org>, 
	"morbo@google.com" <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
	Luis Chamberlain <mcgrof@kernel.org>, Leizhen <thunder.leizhen@huawei.com>, 
	"kees@kernel.org" <kees@kernel.org>, Kernel Team <kernel-team@meta.com>, 
	Matthew Maurer <mmaurer@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,
sorry to join late at the party.

Il giorno gio 8 ago 2024 alle ore 11:59 Petr Mladek <pmladek@suse.com>
ha scritto:
>
> On Wed 2024-08-07 20:48:48, Song Liu wrote:
> >
> >
> > > On Aug 7, 2024, at 8:33=E2=80=AFAM, Sami Tolvanen <samitolvanen@googl=
e.com> wrote:
> > >
> > > Hi,
> > >
> > > On Wed, Aug 7, 2024 at 3:08=E2=80=AFAM Masami Hiramatsu <mhiramat@ker=
nel.org> wrote:
> > >>
> > >> On Wed, 7 Aug 2024 00:19:20 +0000
> > >> Song Liu <songliubraving@meta.com> wrote:
> > >>
> > >>> Do you mean we do not want patch 3/3, but would like to keep 1/3 an=
d part
> > >>> of 2/3 (remove the _without_suffix APIs)? If this is the case, we a=
re
> > >>> undoing the change by Sami in [1], and thus may break some tracing =
tools.
> > >>
> > >> What tracing tools may be broke and why?
> > >
> > > This was a few years ago when we were first adding LTO support, but
> > > the unexpected suffixes in tracing output broke systrace in Android,
> > > presumably because the tools expected to find specific function names
> > > without suffixes. I'm not sure if systrace would still be a problem
> > > today, but other tools might still make assumptions about the functio=
n
> > > name format. At the time, we decided to filter out the suffixes in al=
l
> > > user space visible output to avoid these issues.
> > >
> > >> For this suffix problem, I would like to add another patch to allow =
probing on
> > >> suffixed symbols. (It seems suffixed symbols are not available at th=
is point)
> > >>
> > >> The problem is that the suffixed symbols maybe a "part" of the origi=
nal function,
> > >> thus user has to carefully use it.
> > >>
> > >>>
> > >>> Sami, could you please share your thoughts on this?
> > >>
> > >> Sami, I would like to know what problem you have on kprobes.
> > >
> > > The reports we received back then were about registering kprobes for
> > > static functions, which obviously failed if the compiler added a
> > > suffix to the function name. This was more of a problem with ThinLTO
> > > and Clang CFI at the time because the compiler used to rename _all_
> > > static functions, but one can obviously run into the same issue with
> > > just LTO.
> >
> > I think newer LLVM/clang no longer add suffixes to all static functions
> > with LTO and CFI. So this may not be a real issue any more?
> >
> > If we still need to allow tracing without suffix, I think the approach
> > in this patch set is correct (sort syms based on full name,
>
> Yes, we should allow to find the symbols via the full name, definitely.
>
> > remove suffixes in special APIs during lookup).
>
> Just an idea. Alternative solution would be to make make an alias
> without the suffix when there is only one symbol with the same
> name.
>
> It would be complementary with the patch adding aliases for symbols
> with the same name, see
> https://lore.kernel.org/r/20231204214635.2916691-1-alessandro.carminati@g=
mail.com
>
> I would allow to find the symbols with and without the suffix using
> a single API.

kas_alias isn't handling LTO as effectively as it should.
This is something I plan to address in the next patch version.
Introducing aliases is the best approach I found to preserve current
tools behavior while adding this new feature.
While I believe it will deliver the promised benefits, there is a trade-off=
,
particularly affecting features like live patching, which rely on handling
duplicate symbols.
For instance, kallsyms_lookup_names typically returns the last occurrence
of a symbol when the end argument is not NULL, but introducing aliases
disrupts this behavior.
I'm working on a solution to manage duplicate symbols, ensuring compatibili=
ty
with both LTO and kallsyms_lookup_names.

thanks,
Alessandro

>
> Best Regards,
> Petr

