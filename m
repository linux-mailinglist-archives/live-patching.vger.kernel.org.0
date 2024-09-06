Return-Path: <live-patching+bounces-619-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F21496F136
	for <lists+live-patching@lfdr.de>; Fri,  6 Sep 2024 12:19:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 89D251C23707
	for <lists+live-patching@lfdr.de>; Fri,  6 Sep 2024 10:19:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AF0E1C9DED;
	Fri,  6 Sep 2024 10:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="kfj9foWk"
X-Original-To: live-patching@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08891459FA;
	Fri,  6 Sep 2024 10:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725617983; cv=none; b=hm1uil6/s7otrTrvIsYdxGxmZynaPSQKQH2I2Dg1xmUcyecmdIgq/6q0Q+xW6b/fBB14YnE29K6aIuPCtJSUHBcTnKddyLmiNvc+NQkdLDHqNKmBCcHkkSGtZP0p8whR2XPYiV0BHf8QaPfMEYzOIatlKbc5JrLfms/kr/9IF80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725617983; c=relaxed/simple;
	bh=srodkuBFrYDQvY3Z2yPu1/Qkt9CMCyaM+joC1OF5AJE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xfjo7XeqANQoTpUYSlz5B2l3pdi5nHMf3QHXnxgdklAKXworWPzOZqD6wVgByRg3hRMwM9Kr8hXj+g2zPdwjsTUnN1QjAG73e8pdr8luiKuPznDvXFuCb1L7JbZs3utiNmIGnhDCGpoA9G6gN4+VwToOD6taY+AhqwbhPv58/Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=kfj9foWk; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E4B5F40E0284;
	Fri,  6 Sep 2024 10:19:30 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id N2XDnXbkepOf; Fri,  6 Sep 2024 10:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1725617966; bh=52Bjqy9wKt3PBv7t7YsYKaL/GEu9aXl+PiSD/OpMtcc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kfj9foWkQozT+pk6uixpd8CqfmhsgKwuDezd5/C8Dn/IdycDN7w+HxiO9/ONLAXVo
	 l6fo0fUdbYSUtgR+XjOGJfmOdm6J+3WCF5fogoWz7/M0qx5tJK8zhaccI9SNyIPe3I
	 H0C5B8wHDLL1Z6lpFvkCJnC/ymdnwEhLfte/+DNCfZ8JGMhbZVlsdip0XwCzLA9UiH
	 HqwHBSnj7DleV8KzJ6jNefUV6o76AfUAyjrdUdjPS7Yoza3z1HSzyRlZeyv2ictr8V
	 9QoEF+ClZCrSw5o9aJdeRNqz8Xo/1GlfRTrarDhzaEW+9NUeEvxmk3adoIZ9hn6qVc
	 3xWFyJ8h0UciGfs1iCNJGRgciQqVOhDca8NSc0H3TNFwtTgEY2ZgDFFCtLwlIl6Y9G
	 NrhyOYwzYIEMZ5bdjZRLKhh1qbaACAs5EquKjN8xWqAYN35zd1AMwfRbRj0RSoZUQf
	 d53uoIWbcLbZ0Fz7/7KetL5KdhtuZmnOgWxw+fU/reivADe1a8tUCTio7vtCMGvydV
	 794JqHeJ8IaXQYMUz/vhsPHWTG1e6pxCNbzmrClw3YRWrIV+FNpkTKeR1S8Lu5nhug
	 h/n08xhuciBdw2IHI/aLHCuD5BwI6XqjDbgF83Vgo/oLQG4Nh9em7T8vR0vXwaak9r
	 HX64YnCqiwuXxg4w8FpeqSpw=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A0AA340E0191;
	Fri,  6 Sep 2024 10:19:14 +0000 (UTC)
Date: Fri, 6 Sep 2024 12:19:09 +0200
From: Borislav Petkov <bp@alien8.de>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>, Michael Matz <matz@suse.de>
Subject: Re: [RFC 28/31] x86/alternative: Create symbols for special section
 entries
Message-ID: <20240906101909.GAZtrXHVweqJJ2j82v@fat_crate.local>
References: <cover.1725334260.git.jpoimboe@kernel.org>
 <7bc1bcb1cd875350948f43c77c9895173bd22012.1725334260.git.jpoimboe@kernel.org>
 <20240903082909.GP4723@noisy.programming.kicks-ass.net>
 <20240904042829.tkcpql65cxgzvhpx@treble>
 <20240904123918.GCZthU9rOJLWUKBbsv@fat_crate.local>
 <20240904164429.hstbg5beejt32mlu@treble>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240904164429.hstbg5beejt32mlu@treble>

On Wed, Sep 04, 2024 at 09:44:29AM -0700, Josh Poimboeuf wrote:
> Not that I know of, since the compiler usually doesn't have visibility
> to these sections.
> 
> It might be possible to specify "entsize" in the .pushsection flags,
> which is an ELF section header attribute which objtool could read.
> 
> But that wouldn't work for .altinstr_replacement and other sections with
> variable-size entries.  Also, "objtool klp diff" works by copying
> symbols, so the current solution is definitely simpler as it fits in
> nicely with the rest of the implementation.

Right, I was talking to Michael about it yesterday, CCed.

He suggested that you might be better off creating these annotations by
sticking the required info in a section instead of generating symbols.

I.e.,

.pushsection .klp_objects
 .size \\name\\@, \\end - .\n"
 ...
.popsection

and so this section will be completely out of the way, you won't pollute the
symbol table with countless fake symbols and you can simply parse that section
to get the info you need.

Right?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

