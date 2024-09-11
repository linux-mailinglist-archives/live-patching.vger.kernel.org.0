Return-Path: <live-patching+bounces-649-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D67AD975820
	for <lists+live-patching@lfdr.de>; Wed, 11 Sep 2024 18:20:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9626A28B4EF
	for <lists+live-patching@lfdr.de>; Wed, 11 Sep 2024 16:20:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 169991AD9FF;
	Wed, 11 Sep 2024 16:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CX03Q/vW"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04DB187336;
	Wed, 11 Sep 2024 16:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726071608; cv=none; b=QYc388wQxYvfF1sdRGMmbwd+juTmCPeL+KBdot+SmL63pySEMHx7o1m6wavxao3nkjgz593ZkfMotAI1oA4J1Y0TElTWNFOsfhG/uNDAkNUjcZjHVWDWqe27IJhveTqPBBTYoRQBh0VI5Qv4TYmK4PwrMMwwXJlacYYXyw34zk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726071608; c=relaxed/simple;
	bh=MBGdQo2cBzmQK5M6W3GuoGffk8uzIWlhJSuZ4hN+u7w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oMRqJQVx+3gHlIbFjdmI2sHVO74ndkGTyZqr6ARL3QkB7dmlfzspDo9whnV5UEvUdn3rW8gEstQROPu2hmhSwdcLEf/7j0b2qRhhVpolGFCNzfN9XDHaGs5HyQZOCeUBzH+JUQYbx2M53Rnc+S6ZF88UupI1kpoGVrOUUcEF2Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CX03Q/vW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC3AC4CEC0;
	Wed, 11 Sep 2024 16:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726071607;
	bh=MBGdQo2cBzmQK5M6W3GuoGffk8uzIWlhJSuZ4hN+u7w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CX03Q/vWDL6sfqLkIhCmNQu4tlxVAzqtioclDDC23UWWYH16+6YvRKAzePazsK9k/
	 jjkdOLxx0jhzgxljymjBj7QwXW4U9hsCgBhSNdWjyWeMf2cymxBpRsDkViuS/THChX
	 agGMwnAUcCKTJiWuly2T8keBonwb3Qw8ukkkz4dGPkheo4Z3oHFl/u/yEu0LTglcIZ
	 Vj/8OCW36YoK5C57JHcS7bpvPfWzv6UsPnBCIaAklGrVWxhoYeiH9maF4048Eff4+o
	 fW73n+IA9k/T6KGT3uPNiPlgKe7UlIZHOMAZqfaX70g7tLW6XDCsCny4oaKUm3aOj2
	 m6YjieCzAVJ/Q==
Date: Wed, 11 Sep 2024 09:20:05 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Petr Mladek <pmladek@suse.com>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: Re: [RFC 00/31] objtool, livepatch: Livepatch module generation
Message-ID: <20240911162005.2zbgqrxs3vbjatsv@treble>
References: <cover.1725334260.git.jpoimboe@kernel.org>
 <ZuGav4txYowDpxqj@pathway.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZuGav4txYowDpxqj@pathway.suse.cz>

Hi Petr,

Thank you for trying it out and doing the research to compare it with
kpatch-build.

On Wed, Sep 11, 2024 at 03:27:27PM +0200, Petr Mladek wrote:
> Without -ffunction-sections -fdata-sections:
> 
> 	$> time make -j8
> 	real    0m58.719s
> 	user    3m25.925s
> 	sys     0m21.895s
> 
> With -ffunction-sections -fdata-sections:
> 
> 	$> time make -j8
> 	real    13m28.126s
> 	user    15m43.944s
> 	sys     0m29.142s

That's bad.  We should figure out where those bottlenecks are in the
toolchain.  I know objtool definitely needs improvements there.

For kpatch-build, the production kernel is built *without*
-ffunction-sections and -fdata-sections.  Then those flags get manually
added to CLAGS by kpatch-build for the comparison builds.

We rely on ccache to speed up the repeat builds during development.

Maybe we should do that here as well: only add those flags temporarily
during the klp-build.  That approach seems to work fine for kpatch, as
optimizations are unaffected.

> One obvious area is the support of more architectures. I guess that
> this  code supports only x86_64 at the moment. While kPatch supports
> x86_64, ppc64, and s390. I wonder how complicated it would be to
> support more architectures.

We'll find out soon, as I plan to start work on powerpc once x86 is
done.

I suspect most of the effort is in the objtool port.  However, I believe
it doesn't need the full objtool reverse-engineering functionality, as
it can just calculate the checksum for each instruction in order,
without needing the control flow graph.  So it may be considerably
easier than a full objtool port.

Even if the checksum feature isn't 100% accurate, "almost perfect" is
good enough (see below).

> Also I tried to compare how kPatch and this code do the binary diff
> and found the following:
> 
>   a) It seems that kPatch compares the assembly by "memcmp" while
>      klp-build uses checksum. This looks good.

Yes.

>   b) Both tools have hacks for many special sections and details.
>      I am not sure objtool handles all cases which are handled
>      by kPatch.
> 
>      For example, it seems that kPatch ignores changes in line numbers
>      generated by some macros, see kpatch_line_macro_change_only().
>      I can't find a counter part in objtool.

See scripts/livepatch/adjust-patch-lines which adds #line macros to the
source patch to fix the line count to match the original.  This is both
easier and a lot more robust than the kpatch way of trying to detect it
in the binary.

>   c) It seems that kPatch contains quite complicated code to correlate
>      symbols.
> 
>      For example, it correlates local variables by comparing
>      functions which reference them, see
>      kpatch_correlate_static_local_variables().

Figuring out how to disambiguate the correlation of static local
variables which have the same name is on the TODO list for klp-build.  I
hope to come up with a simpler solution than what kpatch does.

For example, detect when a changed function uses a duplicate-named
static local variable and require the user to manually correlate the
variable somehow.

>      Or kPatch tries to correlate optimized .cold, and .part
>      variants of the code via the parent code, see
>      kpatch_detect_child_functions()
>
>      While klp-build seems to correlate symbols just be comparing
>      the demangled/stripped names, see correlate_symbols().
>      This seems to be quite error prone.
>
>      I actually do not understand how klp-build compares symbols
>      with the same demangled/stripped names. I probably missed
>      a trick somewhere.

A ".cold" variant is considered part of the "parent" function which
jumps to it.  When the checksums are calculated in validate_branch(),
objtool sees the parent jumping to the child, so the child instructions
contribute to the parent's checksum.

When the parent's checksum changes, that will be detected.  The ".cold"
variant will be seen as a new function which is needed by the changed
parent and will be added to the patch file.

At least that's how it works in theory, I need to test this :-)


For standalone mangled functions such as .part which are not branched to
by parent functions:

While the correlation uses the demangled names without the suffix, it
also takes into account what file they belong to, by looking at what
FILE symbol they are beneath in the symbol table.  It also takes the
function order into account.

Since they're static functions, there can't be more than one function
with the same name, though there might be more than one version of it
(e.g., one mangled and one non-mangled).  This can change between the
orig and patched versions, but the function comparisons will detect
all this on the binary level.

While this strategy isn't theoretically bulletproof, it always works in
practice.  Which is good enough.


In the end, there are two hypothetical modes of silent failure with
regard to the correlation and comparison of functions:

  1) Marking a function changed that hasn't changed.  This is mostly
     harmless, as it results in a function getting patched
     unnecessarily.

  2) Missing a changed function.  This is obviously bad.

Unless there's a bug, neither of these happens in practice.  Regardless,
it must be stressed that klp-build is not a toy and the patch author
must always confirm the printed list of changed/added functions matches
exactly what they expect.  And of course they must test it.

> Do not get me wrong. I do not expect that the upstream variant would
> be feature complete from the beginning. I just want to get a picture
> how far it is. The code will be maintained only when it would have
> users. And it would have users only when it would be comparable or
> better then kPatch.

I agree it needs to be fully functional before merge, but only for x86.

Red Hat (and Meta?) will start using it as soon as x86 support is ready,
because IBT/LTO support is needed, which kpatch-build can't handle.

Then there will be an intermediate period where both kpatch-build and
klp-build are used and supported, until the other arches get ported
over.

So I think this should be merged once the x86 support is complete, as it
will have users immediately for those who are running on x86 with IBT
and/or LTO.

-- 
Josh

