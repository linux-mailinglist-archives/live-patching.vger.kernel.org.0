Return-Path: <live-patching+bounces-2729-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WPTRJ5Ph+WlPEwMAu9opvQ
	(envelope-from <live-patching+bounces-2729-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 14:24:51 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 456804CD64D
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 14:24:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 44A813016B4A
	for <lists+live-patching@lfdr.de>; Tue,  5 May 2026 12:24:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 396CF426D39;
	Tue,  5 May 2026 12:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cnj/gdL+"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628F838946A
	for <live-patching@vger.kernel.org>; Tue,  5 May 2026 12:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777983888; cv=none; b=o5VddZG61WQcWhViAYkH3KtJKlik5MK3cu74mxVpmb5M+iMzQYUTfD/OHqKdjGcw6VehDqUlLi8smRzw8eZdLVXYEktf5ssDwOLDyrZJw+QPNVKW1LOwmLMRQR9jvl37IjuK9UR7QdrPkESutc382ouUlJzdq+fTZQhmdjD5Sg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777983888; c=relaxed/simple;
	bh=T60HQbL8qDyAg5IiNgQTk8uqdsTOZsHn/TzRE3z1AbM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mra/jiP1jvRBWTLxJmjuVMKJuwNvPYEOnzn2aGGhf19vjWkZLMaVTGeBZL7Pm/jgvu/Unp10M79tXguuAQM3qawS5iBkZDgil9BfNn4wUR6ryWErLjzkD6qFUAVT8alM9DROVfx/PBcp7iMUfH/hEMAguDifd4WAuec33FcrpgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cnj/gdL+; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-44a044cb827so3628652f8f.0
        for <live-patching@vger.kernel.org>; Tue, 05 May 2026 05:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777983885; x=1778588685; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7yiH2TZpywbFVEglbVYA5/bUDfLfXjzVUSCKuxkRreU=;
        b=cnj/gdL+YLBQrX4yDlj3bwHxc/BaimJFIo/LT+2ZeTyz9TR58jX2qTFdWtuSSJAF6M
         3QO13kQmzU/zQRVbpSQE42Xx+QpQnmFvy0u6v1fsXCOEO22UJTRkms9ohm01t/FaOW3G
         jaX8kF3sbydz1tge4OXh4RbMtBf/oj9UWUbesg0rYY9M4bcgxpYEqueaLR4YQ/SlVtb2
         vjOXnAFZg4un5ydx78MWCwcWGiqtc5+sWF0W93aDgh9pb7o+Vicczk7DC7Cz05GkzGIo
         iociAN9JrOKFcfRrG5owf3NGebyoiYxQK+gB9T4fa4d2j9EpbvmSpMmpl0eG28mDDJer
         taMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777983885; x=1778588685;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7yiH2TZpywbFVEglbVYA5/bUDfLfXjzVUSCKuxkRreU=;
        b=KslmoDPf0kb+Bq2o4JkYFa4wRImIKWnrJnWwjZGRJ8GSbNAFYm7jYdqdLWw9YfmIQ/
         Ri3hvsTPhVqsl7H0ig6d92F8LiL6MZEP/jbqi/RbGWBumwNIrnKtc94Ey6HM9iPPC2K6
         d9ShPLcaEp0go3Kwin+JG9QPs2O2rROkCWeFJY6v2zan5E6fN+xW9p84xWQJqG208/b/
         omCpn+hyAfBekLrV+0vwb71xYV8+6TIVAp3jCJCOpjKovfN86UA4le4/bGUzANzxvB/o
         Z64bj4zvhwrz8lDuz59HXc0eUIA00ULSqD3Gr1DSOvUhWbzeyoS3ZMA376wVqmx7bvvC
         bxiw==
X-Forwarded-Encrypted: i=1; AFNElJ/ovSNvqsb+hVBhUs+M9BdgLdmvhxPgJfySNsdqDxV5e6LMPBR5xqNyHVReyCaOAF4pP0rHDJaP+dRyaaZX@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8/ZwB+UplcO0QftzgfkFPmYOfe3YsU98OCY75bvK5RPdgMVKT
	QllP3DtAGhDG8zIi6PKA41oZwRKfOTpE1GZcu434cOtthFvK7IKXr/NDou+0ypQCsVo=
X-Gm-Gg: AeBDietSaGDpQ6+Ip3neEtO70v0zPYXizcyQ6LAuwz9KimxVLL4xLkjY/njS+Hkgy6V
	29hr3oQqpqU40kA0htdOd33/A8YdIbL0VMaVoVP04OPh4mkUSarF4BusI6LdcUgEj5UUCeP+Xc+
	U/f90GYnG2ICzDoHz+o1PrcJ9FmwUFzqEXffM/Cq0UVQDrg9ONENl6zRUZ8bqI34a8ddffbkZ1C
	sBlN7mHYIgGUp86cOUFrFbTpJV/lPWwIVMJNup15Mn2tZ+UBRPlOSdwm3B4l7j5e1UBzJlQTk1g
	y3ghHNyymJgrHjzqcdTdGMa92j5gcAWnb4kSmWkioUv1uK7hFkqkVIWk2vL4/Re5IMDyJXvdI8q
	OSX4tYBFdiEqazE/Ek2BDbplTGnlhbn+fpQkFI+eTH/bNqtsIc8xXrxmc+g2J5KWwz2+t4/pE58
	Mm1A5ezHnWgqnypOxM1/jXfMm6GE4dO7KdiDOuepyCR8Ca1oU=
X-Received: by 2002:a5d:64c9:0:b0:43d:7d24:b4ff with SMTP id ffacd0b85a97d-44bb772f856mr22057200f8f.40.1777983884553;
        Tue, 05 May 2026 05:24:44 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4505285e765sm4159009f8f.10.2026.05.05.05.24.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 05:24:43 -0700 (PDT)
Date: Tue, 5 May 2026 14:24:41 +0200
From: Petr Mladek <pmladek@suse.com>
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: linux-modules@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, live-patching@vger.kernel.org,
	Daniel Gomez <da.gomez@kernel.org>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Jordan Rome <linux@jordanrome.com>,
	Viktor Malik <vmalik@redhat.com>, Miroslav Benes <mbenes@suse.cz>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH v2 2/2] module/kallsyms: sort function symbols and use
 binary search
Message-ID: <afnhidn7K7dZ_cPh@pathway.suse.cz>
References: <20260327110005.16499-1-stf_xl@wp.pl>
 <20260327110005.16499-2-stf_xl@wp.pl>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327110005.16499-2-stf_xl@wp.pl>
X-Rspamd-Queue-Id: 456804CD64D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2729-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[wp.pl];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	DKIM_TRACE(0.00)[suse.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pmladek@suse.com,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,pathway.suse.cz:mid]

On Fri 2026-03-27 12:00:05, Stanislaw Gruszka wrote:
> Module symbol lookup via find_kallsyms_symbol() performs a linear scan
> over the entire symtab when resolving an address. The number of symbols
> in module symtabs has grown over the years, largely due to additional
> metadata in non-standard sections, making this lookup very slow.
> 
> Improve this by separating function symbols during module load, placing
> them at the beginning of the symtab, sorting them by address, and using
> binary search when resolving addresses in module text.
> 
> This also should improve times for linear symbol name lookups, as valid
> function symbols are now located at the beginning of the symtab.
> 
> The cost of sorting is small relative to module load time. In repeated
> module load tests [1], depending on .config options, this change
> increases load time between 2% and 4%. With cold caches, the difference
> is not measurable, as memory access latency dominates.
> 
> The sorting theoretically could be done in compile time, but much more
> complicated as we would have to simulate kernel addresses resolution
> for symbols, and then correct relocation entries. That would be risky
> if get out of sync.
> 
> The improvement can be observed when listing ftrace filter functions.
> 
> Before:
> 
> root@nano:~# time cat /sys/kernel/tracing/available_filter_functions | wc -l
> 74908
> 
> real	0m1.315s
> user	0m0.000s
> sys	0m1.312s
> 
> After:
> 
> root@nano:~# time cat /sys/kernel/tracing/available_filter_functions | wc -l
> 74911
> 
> real	0m0.167s
> user	0m0.004s
> sys	0m0.175s
> 
> (there are three more symbols introduced by the patch)
> 
> For livepatch modules, the symtab layout is preserved and the existing
> linear search is used. For this case, it should be possible to keep
> the original ELF symtab instead of copying it 1:1, but that is outside
> the scope of this patch.

What is the exact motivation for the special handling of livepatch modules,
please?

Honestly, I am always a bit lost in the various symbol tables. It is
possile that I have got something wrong.

Anyway, my understanding is that there are two aspects which are important
for livepatches:

1. Livepatches need to preserve special symbols which are used to
   relocate symbols which were local in the original code, see
   Documentation/livepatch/module-elf-format.rst

   IMHO, this is why layout_symtab() computes space for all core
   symbols in livepatch modules and copies them in add_kallsyms().

   The symtab is normally released when the module is loaded.
   But livepatch modules make its own copy of the important
   parts, see copy_module_elf().

   IMHO, the sorting of function symbols vs other symbols does
   not matter here. I believe that the special relocation
   symbols are not affected by this.


2. Livepatches _rely on the sorting_ of symbols in the module.
   The special relocation symbols might define a symbol position,
   see

	.klp.sym.objname.symbol_name,sympos

   in the documentation. It defines the position of the symbol
   when there are more symbols of the same name, see
   klp_match_callback() in kernel/livepatch/core.c.

   I am afraid that _this patch might break_ this when it moves
   function symbols before non-funciton ones. I guess that
   the symbols of the same name will not longer be groupped.

Idea: Is the shufling really important for the performance, please?

   I would expect that binary search would have a good performance
   even without the shuffling. It puts aside half of the symbols in
   one cycle.


Note that the binary search in find_kallsyms_symbol() is perfectly
fine. The livepatch code explicitly iterates over all symbols using
module_kallsyms_on_each_symbol(), see klp_find_object_symbol().

Best Regards,
Petr

