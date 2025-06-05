Return-Path: <live-patching+bounces-1490-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0EB1ACF984
	for <lists+live-patching@lfdr.de>; Fri,  6 Jun 2025 00:07:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E8DC3B0385
	for <lists+live-patching@lfdr.de>; Thu,  5 Jun 2025 22:07:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5C4427FD4F;
	Thu,  5 Jun 2025 22:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tIAGL1Gg"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBAD527FD4A;
	Thu,  5 Jun 2025 22:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749161234; cv=none; b=SJbQeDxbwSDGKyGUCMXKFU+w7ZXFf0htEx4+sr+DmLhqz5Nc767yaRHNt3P2pOYuSUcXDy9PlU+qbCIw3Kg4/lPIMvIuOrJCpobFH54r7Gqv1rxAVVzZfjilD866a1YCLHAHQBeylZLhvt1yMRPk1WRDHKZZe+GmJO/eozvCAeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749161234; c=relaxed/simple;
	bh=KQI+vv1JrB/QyxuMj78RiN6j1bY/LrURFGINN8toLT8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a7nbs6nQU44oenG9X7vN/WafQDoZbfdm/dom/M6l1X879Xo1nnpekFz8SzouNji6rABPu000WLcwV54HZ71NavDmWq7jHTU18QCmfO0D8sJIZIpLE+kWSJGptYsHHcoUM5PXOX0dRzSCYvRCPyxgA67Ui3S8mowX3Abe4NucPO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tIAGL1Gg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6012C4AF0B;
	Thu,  5 Jun 2025 22:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749161234;
	bh=KQI+vv1JrB/QyxuMj78RiN6j1bY/LrURFGINN8toLT8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tIAGL1GgE1eYUy6OovNIQWa6AVuCxcJ60tcNOsUgVVQo2tLu6u6UhjVmQ3xLmoHBw
	 /jCzuQWYvFVtwb3qUnoKXthuJPpSLTIoTqRudPi7mfft+un6Iu1XuHAHyEi1IMQdHm
	 Q0KHkwa/DDrPOOmhT/Sd+eT9HBWha6CuUUGFKLpzvEDlViI9qgYj9kSf/EtLlZAiAf
	 7uZJNZGxFuf/5xzgAMxHhUAtSUv6+fUk8jIn5qucTj+y/pbK8QfK0dBT+p0YMZ/2X9
	 GNelrAZH9MDSb/VD8zv1cw48yUPzZTupRjV2XwsgmAcr8Ic5G0vOTii2SSA/7g/Ri0
	 lqG32dARBGywQ==
Date: Thu, 5 Jun 2025 15:07:11 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, 
	Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 52/62] objtool/klp: Introduce klp diff subcommand for
 diffing object files
Message-ID: <6e676p66eq4a5uzzsmm7lidzuwypaapmpv7przqckfiyvv2wgh@2e4tapbyhahw>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <f6ffe58daf771670a6732fd0f741ca83b19ee253.1746821544.git.jpoimboe@kernel.org>
 <20250526185716.GU24938@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250526185716.GU24938@noisy.programming.kicks-ass.net>

On Mon, May 26, 2025 at 08:57:16PM +0200, Peter Zijlstra wrote:
> > @@ -50,10 +51,12 @@ struct section {
> >  	bool _changed, text, rodata, noinstr, init, truncate;
> >  	struct reloc *relocs;
> >  	unsigned long nr_alloc_relocs;
> > +	struct section *twin;
> >  };
> >  
> >  struct symbol {
> >  	struct list_head list;
> > +	struct list_head global_list;
> >  	struct rb_node node;
> >  	struct elf_hash_node hash;
> >  	struct elf_hash_node name_hash;
> > @@ -79,10 +82,13 @@ struct symbol {
> >  	u8 cold		     : 1;
> >  	u8 prefix	     : 1;
> >  	u8 debug_checksum    : 1;
> > +	u8 changed	     : 1;
> > +	u8 included	     : 1;
> >  	struct list_head pv_target;
> >  	struct reloc *relocs;
> >  	struct section *group_sec;
> >  	struct checksum csum;
> > +	struct symbol *twin, *clone;
> >  };
> >  
> >  struct reloc {
> > @@ -100,6 +106,7 @@ struct elf {
> >  	const char *name, *tmp_name;
> >  	unsigned int num_files;
> >  	struct list_head sections;
> > +	struct list_head symbols;
> >  	unsigned long num_relocs;
> >  
> >  	int symbol_bits;
> 
> ISTR us spending significant effort shrinking all this stuff. How does
> this affect vmlinux.o memory footprint etc?

IIRC, most of our shrinking efforts were related to instructions and
relocs, which use up the bulk of the memory.  This set doesn't touch
those.

Before and after the set, with a Fedora config:

  Maximum resident set size (kbytes): 2934116
  Maximum resident set size (kbytes): 2953708

So about ~0.67% more memory.

-- 
Josh

