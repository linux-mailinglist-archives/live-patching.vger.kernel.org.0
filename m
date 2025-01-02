Return-Path: <live-patching+bounces-947-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 037EA9FFA4D
	for <lists+live-patching@lfdr.de>; Thu,  2 Jan 2025 15:16:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B39AA7A182C
	for <lists+live-patching@lfdr.de>; Thu,  2 Jan 2025 14:16:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EE851B3724;
	Thu,  2 Jan 2025 14:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UgwoV387"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95AE192D70
	for <live-patching@vger.kernel.org>; Thu,  2 Jan 2025 14:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735827405; cv=none; b=tfAtcIpzeYHqO/+CyAQK8awnv9/YCjibapYY78Z5LmSI6ih5vZjkJ9TuBGuDbgiy2snYEAcA3ewedKOKzxThAjrJZIIll9MbNKhs3SDBmL5p9Bc5J0R8t/sgGJ7O2TTALX+YgB9r4+UpRZcx/qMYTOu2aZayTa+64TBkftiSoYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735827405; c=relaxed/simple;
	bh=CsCpQsXnlZGrwQ6tjkZO+RdYahDklYmcW3p6FeJDbb4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hgk1qfpbzsuOe5VLR0Rwt10rdG4CybI6lU/EX+t8veqgkMkIJXaKsyKWzqWq1Ghd85AjTyV1+ulhZAD6pABStb/IWafkPMU0/KxiCPvYPpVKlXG+FT4Qn3KvmT7FXVYSlXuZx39xrxqag0TIWEF4IRrV86Qms+yq0Wl4lhfYqgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UgwoV387; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-385df53e559so8954669f8f.3
        for <live-patching@vger.kernel.org>; Thu, 02 Jan 2025 06:16:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1735827400; x=1736432200; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rxeQmEUngUXl43U3DOMKAS+5QyXY4hU1UnyuidxxvAQ=;
        b=UgwoV387gy79JK3K50gA8oyGHtGJtfOMeGu+gNTRVEfNKuyEER9qcoLPN6FiNm9AOL
         tkUGB7i0LAztVBJwQPQFGCVMsTtry25uDHuON9xWEt27W1hwfM73jhabh7OB2GBHkFwy
         d1muJCfe1utuODd7UMzZ09ZHnois5B7sUxC7xmsX2ZDt1/Ovw8OYud8uAaphb3y08+24
         lKpRrYs7UOLFVF1nAMPWX8R44Au6hIum15xQh3/4wAQIuiRRX+89lOBUDGBAAMTQmKC4
         VCbIGdvYClxPctomZ+ee3H0jnh2rizcsoxNOvotbC9ndVKlBTItviNSug0ghgG3akR4T
         JtAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735827400; x=1736432200;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rxeQmEUngUXl43U3DOMKAS+5QyXY4hU1UnyuidxxvAQ=;
        b=Kydapl2VHz6HyjNsfsbjAkv/lsRLeQt1aDULKqJA1xvpMbtrG2sFGTqvmYsFMNgkF2
         DIBzOrM4lXHA+tGn/ORn29+ymel1sZLhNCSqeqpAnZGhMObZNL8ooai2uA1X6Jo3ew8r
         2n2fu4usNNICj/QGvN1AR6/FcH5ZBcvdbEf6uNwfHM4fd8z7lpC79xiOjuVcZPN9O43u
         InJMgpzEcqltNrIm1l2+mSo7g+dMxFN4IAodSSqWxTZUALLI35ebd3F25yhSMq6/q0Tx
         TkqxhtAGoRdApQ9u5Dx99tWgbo5aLKbvshHLvPkA3kY7nLCG2JvHn9oUj8n5owXRp5sv
         HWUQ==
X-Forwarded-Encrypted: i=1; AJvYcCWW5mLm84ahJMRsgpckyV7TQhNRCHC5w2lq5Ej+5eHVI26hcx3QCwCEoEv0yo1GkQuGiwWuUB+F1Qjb5cqe@vger.kernel.org
X-Gm-Message-State: AOJu0YwU7ZK2ttwGV5+4q3ow+4uOTEhGM+cQDeGZZ/yGozrGEd45hWLX
	ux5D1q/63Z6Bk8qrzdkqVxnPivGB6CDprL8lVv50RHn7KiApTNsV3VYarYbD254=
X-Gm-Gg: ASbGncsSt5NpV2lFBeRmwmTzzbhZkswSRBxnnG18F+9MWOxE+uZro+BnAXMeCVG2AWM
	jHM08gpCRD4HYAKY9WonddokO6Sr5FHI+Tl1xXemFKn0SXPXWRAl3e9WoKNOkWPZfebm84xTyP9
	VVXyXZAdYCFT8gFNJI6bb9vzTR6ssf4G+Vxe0ktNoiS4NMmPlqXNNjDmfDQAsmhrp8duJeRJoDz
	86efLIaBER7yogYQ5yKDOWEnBLhO8s5gkFPJ5FOAg5bhnRcnBofAvLueg==
X-Google-Smtp-Source: AGHT+IF0uYcL7D50WlyAx8Vt1APUkhyFRpHrc2CY+y2uVGEJR+MiQFexcrXXw0PArWTHsuRdwTdplw==
X-Received: by 2002:a05:6000:1f8c:b0:385:f89a:402e with SMTP id ffacd0b85a97d-38a221f65c9mr41908200f8f.14.1735827399717;
        Thu, 02 Jan 2025 06:16:39 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436611ea3d5sm457961115e9.5.2025.01.02.06.16.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2025 06:16:39 -0800 (PST)
Date: Thu, 2 Jan 2025 15:16:36 +0100
From: Petr Mladek <pmladek@suse.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
	Daniel Gomez <da.gomez@samsung.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jiri Kosina <jikos@kernel.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-trace-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [PATCH v2 06/28] module: Use RCU in find_module_all().
Message-ID: <Z3afxC738frodOTr@pathway.suse.cz>
References: <20241220174731.514432-1-bigeasy@linutronix.de>
 <20241220174731.514432-7-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241220174731.514432-7-bigeasy@linutronix.de>

On Fri 2024-12-20 18:41:20, Sebastian Andrzej Siewior wrote:
> The modules list and module::kallsyms can be accessed under RCU
> assumption.
> 
> Remove module_assert_mutex_or_preempt() from find_module_all() so it can
> be used under RCU protection without warnings. Update its callers to use
> RCU protection instead of preempt_disable().
> 
> Cc: Jiri Kosina <jikos@kernel.org>
> Cc: Joe Lawrence <joe.lawrence@redhat.com>
> Cc: Josh Poimboeuf <jpoimboe@kernel.org>
> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Miroslav Benes <mbenes@suse.cz>
> Cc: Petr Mladek <pmladek@suse.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: linux-trace-kernel@vger.kernel.org
> Cc: live-patching@vger.kernel.org
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  include/linux/module.h      | 2 +-
>  kernel/livepatch/core.c     | 4 +---
>  kernel/module/kallsyms.c    | 1 +
>  kernel/module/main.c        | 6 ++----
>  kernel/trace/trace_kprobe.c | 9 +++------
>  5 files changed, 8 insertions(+), 14 deletions(-)

I looked primary on the changes in the livepatch code. But the entire
patch looks good to me:

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr

