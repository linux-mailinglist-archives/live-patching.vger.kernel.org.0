Return-Path: <live-patching+bounces-428-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D74F6945E50
	for <lists+live-patching@lfdr.de>; Fri,  2 Aug 2024 15:04:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 15DE31C21144
	for <lists+live-patching@lfdr.de>; Fri,  2 Aug 2024 13:04:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D1031E3CC3;
	Fri,  2 Aug 2024 13:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oJkQJHK+"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CBF15ADAF;
	Fri,  2 Aug 2024 13:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722603876; cv=none; b=R6tu41oYiv15ClksGpbvdq0S9BQrfg6tzxpFSqwrWWMFtlrzLZeFtJD7aQ9zC7Ej7y6WuSxIuRUKhVJ8UxMG4wl4SesiavKHfmE6X/w5ZmE65KgpK1tJ4LM38uILHImZPSIYZB7WEYZGgpvi1qwZcF2wwBGlU2cI3zf2Bpigi08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722603876; c=relaxed/simple;
	bh=VflgIIbp+lhPEiXxccrUrj9diNoe+1N4TMkV1XN+3ls=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=H2sxMijIS38GMmHbr3kV60Fg3SJXMNTJvIJGHdHvTi09LBfZYKIQ12wzRrKN89SgF8bC9x/oIQW0r517v9PqvkClhWt3PrLeYWILufND5TUKLdT7hYTzZaPY+fcYSA8M0LNkwdFTf8ZxfpobP7IAfbG2PJT8UibuO/cFLjBF72M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oJkQJHK+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA1DAC32782;
	Fri,  2 Aug 2024 13:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722603875;
	bh=VflgIIbp+lhPEiXxccrUrj9diNoe+1N4TMkV1XN+3ls=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=oJkQJHK+ZFIkgeOSbbXvv/p9z1KbPzhIXSV/0DEyAc3P0WsohqkKGkxfN90DBOr2p
	 sRxXJ2iyQhTNw7ArC92qhgCRTeHsBWbnu9d3zDB38SXvrj+ZOZEwYk3jbfSk9/Ymkm
	 +yKiy3+J2D04QWOuQalVvFb+/HsaPO8VTY+doSc5u2SIG6AymD47ZegkgafOiXVVVC
	 vOJHCImXh6At3jmdiEtY2gbYeFOrhoas0DuHvid1R+NO1OI1cwOYja2qY+bg7AscUX
	 Uz0YxDMfAns637xTsOq+b0N7h1Vi3zD05laQHcN+47TOX2FFJ6A7zBEHc0IXUB4agM
	 eLq4k1AZRRXiA==
Date: Fri, 2 Aug 2024 22:04:27 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Song Liu <songliubraving@meta.com>
Cc: "Leizhen (ThunderTown)" <thunder.leizhen@huaweicloud.com>, Masami
 Hiramatsu <mhiramat@kernel.org>, Song Liu <song@kernel.org>,
 "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>, LKML
 <linux-kernel@vger.kernel.org>, "linux-trace-kernel@vger.kernel.org"
 <linux-trace-kernel@vger.kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr
 Mladek <pmladek@suse.com>, Joe Lawrence <joe.lawrence@redhat.com>, Nathan
 Chancellor <nathan@kernel.org>, "morbo@google.com" <morbo@google.com>,
 Justin Stitt <justinstitt@google.com>, Luis Chamberlain
 <mcgrof@kernel.org>, Leizhen <thunder.leizhen@huawei.com>,
 "kees@kernel.org" <kees@kernel.org>, Kernel Team <kernel-team@meta.com>,
 Matthew Maurer <mmaurer@google.com>, Sami Tolvanen
 <samitolvanen@google.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/3] kallsyms: Add APIs to match symbol without
 .llmv.<hash> suffix.
Message-Id: <20240802220427.8404fa9081b9a740c4f9cb06@kernel.org>
In-Reply-To: <FE4F231A-5D24-4337-AE00-9B251733EC53@fb.com>
References: <20240730005433.3559731-1-song@kernel.org>
	<20240730005433.3559731-3-song@kernel.org>
	<20240730220304.558355ff215d0ee74b56a04b@kernel.org>
	<5E9D7211-5902-47D3-9F4D-8DEFD8365B57@fb.com>
	<9f6c6c81-c8d1-adaf-2570-7e40a10ee0b8@huaweicloud.com>
	<FE4F231A-5D24-4337-AE00-9B251733EC53@fb.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

Sorry for late reply.

On Fri, 2 Aug 2024 03:45:42 +0000
Song Liu <songliubraving@meta.com> wrote:

> 
> 
> > On Aug 1, 2024, at 6:18 PM, Leizhen (ThunderTown) <thunder.leizhen@huaweicloud.com> wrote:
> > 
> > On 2024/7/31 9:00, Song Liu wrote:
> >> Hi Masami, 
> >> 
> >>> On Jul 30, 2024, at 6:03 AM, Masami Hiramatsu <mhiramat@kernel.org> wrote:
> >>> 
> >>> On Mon, 29 Jul 2024 17:54:32 -0700
> >>> Song Liu <song@kernel.org> wrote:
> >>> 
> >>>> With CONFIG_LTO_CLANG=y, the compiler may add suffix to function names
> >>>> to avoid duplication. This causes confusion with users of kallsyms.
> >>>> On one hand, users like livepatch are required to match the symbols
> >>>> exactly. On the other hand, users like kprobe would like to match to
> >>>> original function names.
> >>>> 
> >>>> Solve this by splitting kallsyms APIs. Specifically, existing APIs now
> >>>> should match the symbols exactly. Add two APIs that matches the full
> >>>> symbol, or only the part without .llvm.suffix. Specifically, the following
> >>>> two APIs are added:
> >>>> 
> >>>> 1. kallsyms_lookup_name_or_prefix()
> >>>> 2. kallsyms_on_each_match_symbol_or_prefix()
> >>> 
> >>> Since this API only removes the suffix, "match prefix" is a bit confusing.
> >>> (this sounds like matching "foo" with "foo" and "foo_bar", but in reality,
> >>> it only matches "foo" and "foo.llvm.*")
> >>> What about the name below?
> >>> 
> >>> kallsyms_lookup_name_without_suffix()
> >>> kallsyms_on_each_match_symbol_without_suffix()
> >> 
> >> I am open to name suggestions. I named it as xx or prefix to highlight
> >> that these two APIs will try match full name first, and they only match
> >> the symbol without suffix when there is no full name match. 
> >> 
> >> Maybe we can call them: 
> >> - kallsyms_lookup_name_or_without_suffix()
> >> - kallsyms_on_each_match_symbol_or_without_suffix()

No, I think "_or_without_suffix" is a bit complicated. If we have

0x1234 "foo.llvm.XXX"
0x2356 "bar"

and user calls

  kallsyms_lookup_name_without_suffix("bar");

This returns "bar"'s address(0x2356). Also,

  kallsyms_lookup_name_without_suffix("foo");

this will returns 0x1234. These commonly just ignore the suffix.
The difference of kallsyms_lookup_name() is that point.

> >> 
> >> Again, I am open to any name selections here.
> > 
> > Only static functions have suffixes. In my opinion, explicitly marking static
> > might be a little clearer.
> > kallsyms_lookup_static_name()
> > kallsyms_on_each_match_static_symbol()

But this is not correctly check the symbol is static or not. If you
check the symbol is really static, it is OK. (return NULL if the symbol
is global.)

Thank you,

> 
> While these names are shorter, I think they are more confusing. Not all
> folks know that only static functions can have suffixes. 
> 
> Maybe we should not hide the "try match full name first first" in the
> API, and let the users handle it. Then, we can safely call the new APIs
> *_without_suffix(), as Masami suggested. 
> 
> If there is no objections, I will send v2 based on this direction. 
> 
> Thanks,
> Song
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

