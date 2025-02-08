Return-Path: <live-patching+bounces-1141-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B7E65A2D856
	for <lists+live-patching@lfdr.de>; Sat,  8 Feb 2025 20:32:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 789EB18876D4
	for <lists+live-patching@lfdr.de>; Sat,  8 Feb 2025 19:32:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EC0C19F120;
	Sat,  8 Feb 2025 19:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lBmk/NDD"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F61A241117;
	Sat,  8 Feb 2025 19:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739043160; cv=none; b=GBIDyoUUsZL5iqs+hE7u8JvhBrlvA5GrqVQml6HuBOINjkfnK9GW2H0pBLvBqFDW7XKoPNKEsWGC81TWa26mrkD4vVcsuBX0Zr4wY94HCjDhaKy0mk0A+L2+MqVIYaT2aaXsXNfxVnTkelafPcEmogrAH2PsJ8skHf2RAv45oBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739043160; c=relaxed/simple;
	bh=QmoOdKF7xvBxUv0mUPDSCbN4+LuqVa5z11mQvmnXgXM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jgs5qsNd649eS0LfBSIcbdHCksrBf3E9MP7BGgVfTOWMtjlZnBPsECR5e8jprfNycSOfgVMVN0+INuZHjYABG2Tvc7JUy7JES2fzRJoesNeidAgl+MNguTJI7NNO82F8EupN2uOt0p+Ps7w3L65t1ybLtKMYl2kmE9E1Ie4Aq9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lBmk/NDD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 693E8C4CED6;
	Sat,  8 Feb 2025 19:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739043159;
	bh=QmoOdKF7xvBxUv0mUPDSCbN4+LuqVa5z11mQvmnXgXM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lBmk/NDD9TDmW8ND/e/w2wuXcb386Gmur9XR9YgT+ApKlvnurGjgrpNSjdy+DwVKi
	 wnTcBZQKh0Ja5DpE/lvgH6USw+dE4c78NHCWO6gs81PTSmisNbBBMRqTIvD+JYJpm9
	 jeE1RPHLOpptvI1E7w8puADfcdWZfdTpzVCHG8Lv/OrY/zydPV7oPdefypwn1AqvVB
	 1bTiSUjTsYywwJ75TUfZGGM4d189ZCNW3+EaXizfoqkwU7sLpJxnqkM+umVDD4lG+p
	 19DLI6wOaSqHdKpaOcJTuUj1e8WfNLhGLgua/gMp5RFjw+lykEW7xzlq4VHhwY5Hke
	 dSy60rajBhPzg==
Date: Sat, 8 Feb 2025 11:32:37 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Yafang Shao <laoar.shao@gmail.com>, Song Liu <song@kernel.org>,
	bpf <bpf@vger.kernel.org>, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/2] livepatch: Add support for hybrid mode
Message-ID: <20250208193237.w3zjcyovgurrin55@jpoimboe>
References: <CALOAHbBZc6ORGzXwBRwe+rD2=YGf1jub5TEr989_GpK54P2o1A@mail.gmail.com>
 <alpine.LSU.2.21.2501311414281.10231@pobox.suse.cz>
 <CALOAHbDwsZqo9inSLNV1FQV3NYx2=eztd556rCZqbRvEu+DDFQ@mail.gmail.com>
 <CAPhsuW4gYKHsmtHsBDUkx7a=apr_tSP_4aFWmmFNfqOJ+3GDGQ@mail.gmail.com>
 <CALOAHbDYFAntFbwMwGgnXkHh1audSoUwG1wFu_4e8P=c=hwZ0w@mail.gmail.com>
 <CAPhsuW4HsTab+w2r23bM52kcM1RBFBKP5ujVdDvxLE9OiqgMdA@mail.gmail.com>
 <CALOAHbAJBwSYju3-XEQwy0O1DNPawuEgmhrV5ECTrL9J388yDw@mail.gmail.com>
 <CAPhsuW51E4epDCrdNcQCG+SzHiyGhE+AocjmXoD-G0JExs9N1A@mail.gmail.com>
 <CALOAHbAaCbvr=F6PBJ+gnQa1WNidELzZW-P2_HmBsZ1tJd6FFg@mail.gmail.com>
 <CAADnVQJZCE-Rh4xghLrruY8DW00cRUq9-ct6d=qfKk8Yc+8=pQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQJZCE-Rh4xghLrruY8DW00cRUq9-ct6d=qfKk8Yc+8=pQ@mail.gmail.com>

On Sat, Feb 08, 2025 at 07:47:12AM -0800, Alexei Starovoitov wrote:
> On Fri, Feb 7, 2025 at 10:42 PM Yafang Shao <laoar.shao@gmail.com> wrote:
> >
> > On Fri, Feb 7, 2025 at 2:01 AM Song Liu <song@kernel.org> wrote:
> > >
> > > On Wed, Feb 5, 2025 at 6:55 PM Yafang Shao <laoar.shao@gmail.com> wrote:
> > > [...]
> > > > > I think we should first understand why the trampoline is not
> > > > > freed.
> > > >
> > > > IIUC, the fexit works as follows,
> > > >
> > > >   bpf_trampoline
> > > >     + __bpf_tramp_enter
> > > >        + percpu_ref_get(&tr->pcref);
> > > >
> > > >     + call do_exit()
> > > >
> > > >     + __bpf_tramp_exit
> > > >        + percpu_ref_put(&tr->pcref);
> > > >
> > > > Since do_exit() never returns, the refcnt of the trampoline image is
> > > > never decremented, preventing it from being freed.
> > >
> > > Thanks for the explanation. In this case, I think it makes sense to
> > > disallow attaching fexit programs on __noreturn functions. I am not
> > > sure what is the best solution for it though.
> >
> > There is a tools/objtool/noreturns.h. Perhaps we could create a
> > similar noreturns.h under kernel/bpf and add all relevant functions to
> > the fexit deny list.
> 
> Pls avoid copy paste if possible.
> Something like:
> 
> BTF_SET_START(fexit_deny)
> #define NORETURN(fn) BTF_ID(func, fn)
> #include "../../tools/objtool/noreturns.h"
> 
> Should work?
> 
> Josh,
> maybe we should move noreturns.h to some common location?

The tools code is meant to be independent from the kernel, but it could
be synced by copying it to both include/linux and tools/include/linux,
and then make sure it stays in sync with tools/objtool/sync-check.sh.

However, noreturns.h is manually edited, and only for some arches.  And
even for those arches it's likely not exhaustive: we only add to it when
we notice an objtool warning, and not all calls to noreturns will
necessarily trigger a warning.  So I'd be careful about relying on that.

Also that file is intended to be temporary, there have been proposals to
add compiler support for annotating noreturns.  That hasn't been
implemented yet, help wanted!

I think the noreturn info is available in DWARF, can that be converted
to BTF?

Or is there some way to release outstanding trampolines in do_exit()?

-- 
Josh

