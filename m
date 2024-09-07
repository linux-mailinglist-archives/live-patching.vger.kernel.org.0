Return-Path: <live-patching+bounces-632-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 19E0B970406
	for <lists+live-patching@lfdr.de>; Sat,  7 Sep 2024 22:14:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 921D3B236FC
	for <lists+live-patching@lfdr.de>; Sat,  7 Sep 2024 20:14:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90EDF166F38;
	Sat,  7 Sep 2024 20:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pMnJb1HT"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4BA15F323;
	Sat,  7 Sep 2024 20:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725740088; cv=none; b=sxnhMD85aJYs86HoDkrQUYyYG3NYW922xI48JUQeQQFGcK6a8y4T6JbrV974ZHuHM7qUiZikp/fXUbh7DdyalA75EvGsOOqM+J8OkLy4dpvzCIRtFYbjaXkI2W7/xrf9CXXmYS8ibc8xQWMrbx9435/H4lUKXOmZC4YnTzVTr1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725740088; c=relaxed/simple;
	bh=uSF7+D5QVPmF9zf81HWAoo8GbEiBgkgqOqNWFw6vFSQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ttCREbp2//eNFTGopAoIxxCvHl6Jm9kDxSzBKoeL++zzjbtQp7TifB7wYOMwY82Z4CJPjZf5isR1X7t8E873hSIaglLtmr1OoM1p5xY+ns7MnjMR+Dr42nF6eBH1uODjs9Zcd/fdmyXMvOeZx9zgcAv0GnEKFxh4VCByQsnjFBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pMnJb1HT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A289C4CEC2;
	Sat,  7 Sep 2024 20:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725740087;
	bh=uSF7+D5QVPmF9zf81HWAoo8GbEiBgkgqOqNWFw6vFSQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pMnJb1HTipZpxftnBxY+FtgqhZPg2+dJdTVsKA86mqadRipR03+t7u+LVk89c1kwn
	 ShiSx94e09CZHVcjO1aY5r9Cro7RwCZtHEQwrs0qvpQaCRMPIjg0zBUg2kE//YALu3
	 Zd44+7m442zGZlNtNWt4KdQFbBgP5A44PO81GcE+aCg6Q6k8WKGyw29xmeZPSj3taG
	 pChpnJIhIn6Bx3n+dXI9AAWGccudLo9yu0gHCvnjyzEoRb1htEEf78+WnvHlSY7QWo
	 XfgCYfa8GrGXETLZSTveqxk4KZmpdHSwT+NlHCvODLT55gXX58ZKNWok76bcEgddha
	 vrzIj7WRopHRg==
Date: Sat, 7 Sep 2024 13:14:45 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Song Liu <song@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: Re: [RFC 00/31] objtool, livepatch: Livepatch module generation
Message-ID: <20240907201445.pzdgxcmqwusipwzh@treble>
References: <cover.1725334260.git.jpoimboe@kernel.org>
 <CAPhsuW6V-Scxv0yqyxmGW7e5XHmkSsHuSCdQ2qfKVbHpqu92xg@mail.gmail.com>
 <20240907064656.bkefak6jqpwxffze@treble>
 <CAPhsuW4hNABZRWiUrWzA6kbiiU1+LpnsSCaor=Wi8hrCzHwONQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPhsuW4hNABZRWiUrWzA6kbiiU1+LpnsSCaor=Wi8hrCzHwONQ@mail.gmail.com>

On Sat, Sep 07, 2024 at 10:43:10AM -0700, Song Liu wrote:
> clang gives the following:
> 
> elf.c:102:1: error: unused function '__sym_remove' [-Werror,-Wunused-function]
>   102 | INTERVAL_TREE_DEFINE(struct symbol, node, unsigned long, __subtree_last,
>       | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   103 |                      __sym_start, __sym_last, static inline, __sym)
>       |                      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> /data/users/songliubraving/kernel/linux-git/tools/include/linux/interval_tree_generic.h:65:15:
> note: expanded from macro 'INTERVAL_TREE_DEFINE'
>    65 | ITSTATIC void ITPREFIX ## _remove(ITSTRUCT *node,
>                \
>       |               ^~~~~~~~~~~~~~~~~~~
> <scratch space>:155:1: note: expanded from here
>   155 | __sym_remove
>       | ^~~~~~~~~~~~
> 1 error generated.

Here's how __sym_remove() is created:

#define INTERVAL_TREE_DEFINE(ITSTRUCT, ITRB, ITTYPE, ITSUBTREE,		      \
			     ITSTART, ITLAST, ITSTATIC, ITPREFIX)	      \
...
									      
ITSTATIC void ITPREFIX ## _remove(ITSTRUCT *node,			      \
				  struct rb_root_cached *root)		      \

INTERVAL_TREE_DEFINE(struct symbol, node, unsigned long, __subtree_last,
		     __sym_start, __sym_last, static inline, __sym)

ITSTATIC is 'static inline' so it shouldn't be complaining about it
being unused, right?

If you add -E to the cflags to get preprocessed output, can you confirm
__sym_remove() is 'static inline'?

-- 
Josh

