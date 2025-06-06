Return-Path: <live-patching+bounces-1494-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BD6FACFDB4
	for <lists+live-patching@lfdr.de>; Fri,  6 Jun 2025 09:48:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73F013A86D1
	for <lists+live-patching@lfdr.de>; Fri,  6 Jun 2025 07:48:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EE8728466C;
	Fri,  6 Jun 2025 07:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZsAcAu25"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E997F2040B6;
	Fri,  6 Jun 2025 07:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749196100; cv=none; b=fr8CjWu3XDd39uM61/Ru46FTvWc8HVSS24kKMAtF5N2dtjfkSG5EpIIo4PZN89KAPJvHTep1UMmTe7Fp4pVfW0eiBEQ3OnJb5xCBO25ePypDmcoLmBHORbK7GHahZHVZ9yFDZoXy8wx8J9su9mC84QNYOKU3+Bgn87LuiGxQyjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749196100; c=relaxed/simple;
	bh=1lyT6/ggF8H/20v1VH5TAvkcGgpr88gmBLXo+zbawbE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LDUOCmNiSpBdb6OmGj6gRt2ESO4rgD7oZgn7kOsVGAX4Fe6HKfwPdGp0UE4ueKMjLv7S18/o4YqG1Gfudm6TluFJzavoeA4Asigwb+hUcflurgtMpsDjEoqJWxdyR97PHSuphLUMVLPHNAJDl2jMTgiitvda3n47UJsJTq4EV9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZsAcAu25; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E1DC4CEEB;
	Fri,  6 Jun 2025 07:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749196098;
	bh=1lyT6/ggF8H/20v1VH5TAvkcGgpr88gmBLXo+zbawbE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZsAcAu25F6VPID9J/5RyNWUt1GPkdT9QvCShutxf/NXx4XP9mEkdLA4VokB3gF43j
	 5R2JS+h+bDWFwhShMkphYRMQPGIpEIUYYuqUPKVzTgTkdvsOoL6M638tyt65LYrS4R
	 nrL6pjfCK6xwPLe+jd+yB/3OEZI2+5ZeY+OIpCssWTevBt7FX75NbwW6QoVYuseWzI
	 EG9bXbEp896eF9yAcF7f/4+qqzB4657qnHNjyv+DMYuIdAMKvMbjRFA4FRGPJoHIYh
	 SxqYWjKDf4DXlWk11BDPIsD9UvjgfaH+hs5d3PyxvEmiD+19+kIaImpvhi5zGax3m9
	 2hjAMNCzS8apA==
Date: Fri, 6 Jun 2025 00:48:15 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Brian Gerst <brgerst@gmail.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, 
	Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 45/62] x86/extable: Define ELF section entry size for
 exception tables
Message-ID: <goiggh4js4t3g54fpcs6gugmp26uoumucszrx3e5cdrqdl7336@qijkbpy747jb>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <198cfbd12e54dfce1309828e146b90b1f7b200a5.1746821544.git.jpoimboe@kernel.org>
 <CAMzpN2jbdRJWhAWOKWzYczMjXqadg_braRgaxyA080K9G=xp0g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMzpN2jbdRJWhAWOKWzYczMjXqadg_braRgaxyA080K9G=xp0g@mail.gmail.com>

On Thu, Jun 05, 2025 at 11:58:23PM -0400, Brian Gerst wrote:
> On Fri, May 9, 2025 at 4:51 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> >
> > In preparation for the objtool klp diff subcommand, define the entry
> > size for the __ex_table section in its ELF header.  This will allow
> > tooling to extract individual entries.
> >
> > Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> > ---
> >  arch/x86/include/asm/asm.h | 20 ++++++++++++--------
> >  kernel/extable.c           |  2 ++
> >  2 files changed, 14 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
> > index f963848024a5..62dff336f206 100644
> > --- a/arch/x86/include/asm/asm.h
> > +++ b/arch/x86/include/asm/asm.h
> > @@ -138,15 +138,17 @@ static __always_inline __pure void *rip_rel_ptr(void *p)
> >
> >  # include <asm/extable_fixup_types.h>
> >
> > +#define EXTABLE_SIZE 12
> 
> Put this in asm-offsets.c instead.

But that's only for .S code right?  This is also needed for inline asm.

-- 
Josh

