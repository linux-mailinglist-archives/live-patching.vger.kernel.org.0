Return-Path: <live-patching+bounces-1217-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 84485A3A5EB
	for <lists+live-patching@lfdr.de>; Tue, 18 Feb 2025 19:42:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DC5A51896715
	for <lists+live-patching@lfdr.de>; Tue, 18 Feb 2025 18:42:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8466F1EB5E6;
	Tue, 18 Feb 2025 18:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BsAtfCe3"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE0F17A30E;
	Tue, 18 Feb 2025 18:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739904061; cv=none; b=iS64ZJ161D/Nj9fN1E6+eX49rTEGw10MJr3igr0Y7fxw7TnOwNbhO/lBs9SZpR3Xcd8xKCqdAREWLvwFE2eh/T8xwzth/WbH2mNFORDTxzXHZi2F4X3Gq8rMtvBa2/l9JvtPN36AokpWvRUWG0cmhTc/6lw8DUCxGy/vSKelRgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739904061; c=relaxed/simple;
	bh=iSn5qlkSLrvY9fduNUiNVom2UONzE20CK92zMJiRyX0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HG2qwFPZ11xrxpBtfgB15Tm0EFC5w2te6LE18IXIHgK/S4io1mxS4r+M14azoJA46cpAW41wy5990vtt9ovK6/eYMAZbQpB588aE7tZy2xHHNxxX7+G83viKbSNop9l5L2NSVOf8j1GErJ2jJ9/tHpl9N02LOuc5T8dW07NRCEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BsAtfCe3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D09C4CEE2;
	Tue, 18 Feb 2025 18:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739904061;
	bh=iSn5qlkSLrvY9fduNUiNVom2UONzE20CK92zMJiRyX0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BsAtfCe3TAKsKWVtlrXywIPoIXoilqgNSNTs7nYiJc7ox+cXZyshjoUv90wT0Osem
	 gKt4dti+h3LbR+hjEVOSXF7DiCIUmTSBgEf3brOEfXA+gBYKnfp9lAHfcjIqppqwNt
	 O5iJVnxAaW2giwyDCoTCa9J6qAIjM/78Mf9KEXnbHmNtRjFQJlDkwRmqVWBmvInh9W
	 gOgfC4YJKTDkZQCamXcn2rQd2ZGzCemGdD3+fRrh1A8cslNK2eJQAq5fYaKg/lVd1P
	 /An9oyr5gEw/rirR+v1fnVuI/KKCf5++5RsZhyZBnRErWxl5d3wj7xTVZYK0ET9teO
	 nEMH/LLtJf9gw==
Date: Tue, 18 Feb 2025 10:40:59 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Puranjay Mohan <puranjay@kernel.org>, Weinan Liu <wnliu@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Indu Bhagat <indu.bhagat@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Mark Rutland <mark.rutland@arm.com>, roman.gushchin@linux.dev,
	Will Deacon <will@kernel.org>, Ian Rogers <irogers@google.com>,
	linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org, joe.lawrence@redhat.com,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
Message-ID: <20250218184059.iysrvtaoah6e4bu4@jpoimboe>
References: <mb61py0yaz3qq.fsf@kernel.org>
 <CAPhsuW7dV7UR3PsGVx_DLBH5-95DAmLMGTPuY0NfUwWLZMSTrQ@mail.gmail.com>
 <20250214080848.5xpi2y2omk4vxyoj@jpoimboe>
 <CAPhsuW6dxPtgqZaHrZEVhQXwm2+sETreZnGybZXVKYKfG9H6tg@mail.gmail.com>
 <20250214193400.j4hp45jlufihv5eh@jpoimboe>
 <CAPhsuW6q+yhn0pGQb0K+RhXHYDkjEgomZ2pu3P_MEeX+xNRe0g@mail.gmail.com>
 <20250214232342.5m3hveygqb2qafpp@jpoimboe>
 <CAPhsuW48h11yLuU7uHuPgYNCzwaxVKG+TaGOZeT7fR60+brTwA@mail.gmail.com>
 <20250218063702.e2qrpjk4ylhnk5s7@jpoimboe>
 <CAPhsuW5ZauBrSz11cvVtG5qQBfNmbcwPgMf=BScHtyZfHvK4FQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW5ZauBrSz11cvVtG5qQBfNmbcwPgMf=BScHtyZfHvK4FQ@mail.gmail.com>

On Tue, Feb 18, 2025 at 10:20:10AM -0800, Song Liu wrote:
> Hi Josh,
> 
> On Mon, Feb 17, 2025 at 10:37 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> >
> > On Mon, Feb 17, 2025 at 08:38:22PM -0800, Song Liu wrote:
> > > On Fri, Feb 14, 2025 at 3:23 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> > > > Poking around the arm64 module code, arch/arm64/kernel/module-plts.c
> > > > is looking at all the relocations in order to set up the PLT.  That also
> > > > needs to be done for klp relas, or are your patches already doing that?
> > >
> > > I don't think either version (this set and my RFC) added logic for PLT.
> > > There is some rela logic on the kpatch-build side. But I am not sure
> > > whether it is sufficient.
> >
> > The klp relas looked ok.  I didn't see any signs of kpatch-build doing
> > anything wrong.  AFAICT the problem is that module-plts.c creates PLT
> > entries for regular relas but not klp relas.
> 
> In my tests (with printk) module-plts.c processes the .
> klp.rela.vmlinux..text.copy_process section just like any other .rela.*
> sections. Do we need special handling of the klp.rela.* sections?

Ok, I see how it works now:

klp_write_section_relocs()
	apply_relocate_add()
		module_emit_plt_entry()
  
If that code is working correctly then I'm fresh out of ideas...

-- 
Josh

