Return-Path: <live-patching+bounces-1736-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AF4EBC5910
	for <lists+live-patching@lfdr.de>; Wed, 08 Oct 2025 17:27:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E1A9A3A7FCE
	for <lists+live-patching@lfdr.de>; Wed,  8 Oct 2025 15:27:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D398A2F3607;
	Wed,  8 Oct 2025 15:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gVPWv9Kb"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED802EBBA8;
	Wed,  8 Oct 2025 15:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759937269; cv=none; b=Xg8c1mwkwUua7gmgVinV5X7NEVMKY4+a4ZUxlXGuQabDn8WM88Hmy/nXnmdssBmxguKhaa6vPX2rIkzieV1GiiaFy4pcF5KXuWXVnxuTrlOhKEZLbVbVVDzbsy5vfquIUNaDwBB3Cr7QkheEMNKe7xJu1XFQ15xdTGRVCVivLFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759937269; c=relaxed/simple;
	bh=m/gtv3txD5nG4mkTfb82QKREplefXMZgkwqiSnws77A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nC23kK+YPdIViV92M7OCqiEhGrnyVtDcUVTh2dB76davG/ubyxNWaUT8/gtWhZ8iDXnR5PdVU7+GLuB0p2RBRmh3AQVXnnflVOCYvKdTuhRpnx37rvXaMI34O5sbyBZWrsgei6nK+Rpr/UQ+jpqaUkiqdJNyENnFMLzHo8eBfRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gVPWv9Kb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 446F5C4CEE7;
	Wed,  8 Oct 2025 15:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759937268;
	bh=m/gtv3txD5nG4mkTfb82QKREplefXMZgkwqiSnws77A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gVPWv9Kb/h6zVn7KKibvBMp9NGAN+7ts+svazfyNIN5MJDlqa4+YD1XpLI3+S2sk3
	 qUHNnACmwBRys/ww9v+64KxhlfYHFyiuViKfOhLvOFC70hvb6X0vWaauNeop1ln6D4
	 nHsxSkA0AjUF53irjYN86tVT+YhzC5I1CCMSyBOf13AvMqEkFMIZoTtTk+hvssv98V
	 n5r36F4A2Q4n97O+5AYMFFX4epM3uYWdNLYGsA9SkZ8xc88TYZfB8QDolwB91dBKtt
	 1SUE0FU/Xxpv+5fOh88bmKxvTzMSncijGUD0SgPaijPoZD1xmYRJWAmSowVO7IPKAv
	 7/WD7ymaqf1bg==
Date: Wed, 8 Oct 2025 08:27:45 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Petr Mladek <pmladek@suse.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Miroslav Benes <mbenes@suse.cz>, Joe Lawrence <joe.lawrence@redhat.com>, 
	live-patching@vger.kernel.org, Song Liu <song@kernel.org>, laokz <laokz@foxmail.com>, 
	Jiri Kosina <jikos@kernel.org>, Marcos Paulo de Souza <mpdesouza@suse.com>, 
	Weinan Liu <wnliu@google.com>, Fazla Mehrab <a.mehrab@bytedance.com>, 
	Chen Zhongjin <chenzhongjin@huawei.com>, Puranjay Mohan <puranjay@kernel.org>, 
	Dylan Hatch <dylanbhatch@google.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v4 51/63] objtool/klp: Introduce klp diff subcommand for
 diffing object files
Message-ID: <bnipx2pvsyxcd27uhxw5rr5yugm7iuint6rg3lzt3hdm7vkeue@g3wzb7kyr5da>
References: <cover.1758067942.git.jpoimboe@kernel.org>
 <702078edac02ecf79f869575f06c5b2dba8cd768.1758067943.git.jpoimboe@kernel.org>
 <aOZuzj0vhKPF1bcW@pathway.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aOZuzj0vhKPF1bcW@pathway.suse.cz>

On Wed, Oct 08, 2025 at 04:01:50PM +0200, Petr Mladek wrote:
> On Wed 2025-09-17 09:03:59, Josh Poimboeuf wrote:
> > +static int read_exports(void)
> > +{
> > +	const char *symvers = "Module.symvers";
> > +	char line[1024], *path = NULL;
> > +	unsigned int line_num = 1;
> > +	FILE *file;
> > +
> > +	file = fopen(symvers, "r");
> > +	if (!file) {
> > +		path = top_level_dir(symvers);
> > +		if (!path) {
> > +			ERROR("can't open '%s', \"objtool diff\" should be run from the kernel tree", symvers);
> > +			return -1;
> > +		}
> > +
> > +		file = fopen(path, "r");
> > +		if (!file) {
> > +			ERROR_GLIBC("fopen");
> > +			return -1;
> > +		}
> > +	}
> > +
> > +	while (fgets(line, 1024, file)) {
> 
> Nit: It might be more safe to replace 1024 with sizeof(line).
>      It might be fixed later in a separate patch.

Indeed.

> > +/*
> > + * Klp relocations aren't allowed for __jump_table and .static_call_sites if
> > + * the referenced symbol lives in a kernel module, because such klp relocs may
> > + * be applied after static branch/call init, resulting in code corruption.
> > + *
> > + * Validate a special section entry to avoid that.  Note that an inert
> > + * tracepoint is harmless enough, in that case just skip the entry and print a
> > + * warning.  Otherwise, return an error.
> > + *
> > + * This is only a temporary limitation which will be fixed when livepatch adds
> > + * support for submodules: fully self-contained modules which are embedded in
> > + * the top-level livepatch module's data and which can be loaded on demand when
> > + * their corresponding to-be-patched module gets loaded.  Then klp relocs can
> > + * be retired.
> 
> I wonder how temporary this is ;-) The comment looks optimistic. I am
> just curious. Do you have any plans to implement the support for
> the submodules... ?

I actually already have a working POC for that, but didn't want to make
the patch set even longer ;-)

It was surprisingly easy and straightforward to implement.

> PS: To make some expectations. I am not doing a deep review.
>     I am just looking at the patchset to see how far and mature
>     it is. And I just comment what catches my eye.
> 
>     My first impression is that it is already in a pretty good state.
>     And I do not see any big problem there. Well, some documentation
>     would be fine ;-)
> 
>     What are your plans, please?

From my perspective, it's testing well and in a good enough state for
merging soon (after the merge window?), if there aren't any objections
to that.

There will be more patches to come, like the submodules and other arch
support.  And of course there will be bugs discovered by broader
testing.  But I think this is a good foundation to begin with.

And the sooner we can get people using this, the sooner we can start
deprecating kpatch-build, which would be really nice.

-- 
Josh

