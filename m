Return-Path: <live-patching+bounces-450-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 290B094AAE2
	for <lists+live-patching@lfdr.de>; Wed,  7 Aug 2024 16:59:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D2FDB282D78
	for <lists+live-patching@lfdr.de>; Wed,  7 Aug 2024 14:59:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41040823A9;
	Wed,  7 Aug 2024 14:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AomYONQg"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9CC81741;
	Wed,  7 Aug 2024 14:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723042746; cv=none; b=c7RKLtU35+m9g+lwPV6dQGvhzqo+tcAF5birZU9kFDgBBR7crfHiALGIfINcjZduMkouTs1dBaCvFG0eReLyo7oMyP9D6TAQNcC006yJbNJwAvJ56c/Y9VkchlQwpJ2K82l/1Oz0xIoJBrwadYcHlRRZa4WXhyanZzvQjei004A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723042746; c=relaxed/simple;
	bh=jIZP+sl5/iGS7v+002+u+LGIiUOJgvJy5rw6ynbQTrw=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Thd3JcRXIsmGSkMTQLDS+y2L+YaDCitWoevTk1gZG3dnhllLjFyJPFPmH28srwy0GUciKhahUDV1W0pVchutABRl9rKi3az1nTDujzFVibFVG75lDlCzCjPLMyT2999+Rv3sbgPR8s/SqNcGIEyqtp1Wap3ubU5W83uuhROBTAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AomYONQg; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-71871d5e087so1140843a12.1;
        Wed, 07 Aug 2024 07:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723042744; x=1723647544; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jIZP+sl5/iGS7v+002+u+LGIiUOJgvJy5rw6ynbQTrw=;
        b=AomYONQguoWf/a1cj5l6r7Q1uvvQz3zfOUljhZfFCl/BqIeJAykfHC1R2JdD7qCXjv
         7X6vuTWFW5+A8Om6GzI2M7Uul1l5yXFmY/dFh2l9L3MoJtmKjBgW1j97ggsnscbqT89K
         Idy583StQMCtFS0XYHETGvA9cGnFhxhcVO6qPmJsQZO22nSL4NcnWbAevcn2t1GwkwHt
         1jRxeM+q5E61iMxU1E3SM2xulh9AwdqBYm4uadgmMIBhTMqAi9TANoY9ENEzzLMwyYR3
         nUTZ4yr94TDyx1Gd0Q5PzD0M2GNDRrC8ymQoXzBPDQBMEtMogTrIDB0628rDwGu6wiPc
         Pjpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723042744; x=1723647544;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jIZP+sl5/iGS7v+002+u+LGIiUOJgvJy5rw6ynbQTrw=;
        b=e+XToCuuLs7J/xqIHWVxMdZwo8K2cJOr4BTr4wVS3XgyhVDasY7gtHmNN4CvxnBLRc
         Lv6QK5WKGH8ufhupUzX4dz7esyttTxhkTITq81SuLBYSqKZ342xqIeM1Ukt6MMxuIJt4
         hdTkjMJUNosAWXs+bDQziKYp0alltXJ53wEGRwsqIAbJ+1+ph7EPtiajD/YAm7+D63DJ
         MvcchEms9xNFUqHEyZVYzTLgO2fNFAKX/u7n69f+WI2UrxGcwxhC3t2auPAlXUZDYEZh
         1Qx2YIkE7F1QHQmepC/cjPBbJMjAoJU0e0MH+L1Stn3IAVhPT/EkACNBKFkcB/cwpCWF
         KjOA==
X-Forwarded-Encrypted: i=1; AJvYcCV17Zl4SbAI5d8UGSMNVDC9KUclg0oiSA9AHfyPIh+UkrgdzUwAto7Wn137RyEnvXsEsY0rkcfL0SdkCZmUVxv3Ai0bUJ+sSDFDEEKig7Xzat39Lclqoz8eWwlFXTW+l3bHwT+Q9nBObew5iDqsglTodU1Zl1d3Z1LMFcHicH+DYebXTWKJk6bLUKM9gntSHg==
X-Gm-Message-State: AOJu0YwrwryXL4QzV1VP8GzMK8MvVJW3GTP2QVCu24v0LCVNPRod/MG6
	bugBKiLtd0/hPK+ta4VV+5pWWcrfprBnuXg9MJ4GzVoBZJha30fs
X-Google-Smtp-Source: AGHT+IEdFO0DZXDicBs2YtJa8wnYLQgX0gWvZJCaWeA2D/Fqngr0IrjmGs2S8E5C38UI9Lm2WpxoaQ==
X-Received: by 2002:a05:6a20:12d1:b0:1c4:87d5:c7c8 with SMTP id adf61e73a8af0-1c699550d42mr22562207637.3.1723042743916;
        Wed, 07 Aug 2024 07:59:03 -0700 (PDT)
Received: from smtpclient.apple ([47.89.225.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7106ed2ac2dsm8488114b3a.194.2024.08.07.07.58.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2024 07:59:03 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH v2 3/3] tracing/kprobes: Use APIs that matches symbols
 without .XXX suffix
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <6F6AC75C-89F9-45C3-98FF-07AD73C38078@fb.com>
Date: Wed, 7 Aug 2024 22:58:45 +0800
Cc: Steven Rostedt <rostedt@goodmis.org>,
 Song Liu <song@kernel.org>,
 "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>,
 "linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
 Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>,
 Petr Mladek <pmladek@suse.com>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 Nathan Chancellor <nathan@kernel.org>,
 "morbo@google.com" <morbo@google.com>,
 Justin Stitt <justinstitt@google.com>,
 Luis Chamberlain <mcgrof@kernel.org>,
 Leizhen <thunder.leizhen@huawei.com>,
 "kees@kernel.org" <kees@kernel.org>,
 Kernel Team <kernel-team@meta.com>,
 Matthew Maurer <mmaurer@google.com>,
 Sami Tolvanen <samitolvanen@google.com>,
 Masami Hiramatsu <mhiramat@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <87F7024C-9049-4573-829B-79261FC87984@gmail.com>
References: <20240802210836.2210140-1-song@kernel.org>
 <20240802210836.2210140-4-song@kernel.org>
 <20240806144426.00ed349f@gandalf.local.home>
 <B53E6C7F-7FC4-4B4B-9F06-8D7F37B8E0EB@fb.com>
 <20240806160049.617500de@gandalf.local.home>
 <20240806160149.48606a0b@gandalf.local.home>
 <6F6AC75C-89F9-45C3-98FF-07AD73C38078@fb.com>
To: Song Liu <songliubraving@meta.com>
X-Mailer: Apple Mail (2.3774.500.171.1.1)


> In my GCC built, we have suffixes like ".constprop.0", ".part.0", =
".isra.0",=20
> and ".isra.0.cold".=20

A fresher's eye, I met sometime when try to build a livepatch module and =
found some mistake caused by ".constprop.0" ".part.0" which is generated =
by GCC.

These section with such suffixes is special and sometime the symbol =
st_value is quite different. What is these kind of section (or symbol) =
use for?

Regards
Wardenjohn



