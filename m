Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C235A6BF653
	for <lists+live-patching@lfdr.de>; Sat, 18 Mar 2023 00:31:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbjCQXb1 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Mar 2023 19:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjCQXb0 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Mar 2023 19:31:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D74151FB0;
        Fri, 17 Mar 2023 16:31:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24FD960B81;
        Fri, 17 Mar 2023 23:31:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316C3C433D2;
        Fri, 17 Mar 2023 23:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679095884;
        bh=BKv2lCgkapt88k5JeE6qHL3HDvWVl7vxGoYxVYQNE6g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AZS77oFPc8vjt+NncTCzc4g5EY3J3gWnYeRoc2YSm+RS4YyFYLI8uZALE3Il4OSIU
         COeo5BuUNlxyKdh0no6EKsx2h4/O0mGmXcBvUmxaUZLvoOtD8eaFEg4e+xcWb+9gfm
         +EHeTbpFPV0M4xhcfEJZnAmfSMySgJcJaleWErkL5z3WfJPk6ZOBss195aDbL4PWB/
         F3vCgvtdSe1u3WQyzINZxVvaRYchT7RtdfGlFn0+Dfcfwad73hANwBkKmsMv82e7AE
         pFpqMhEjKrwMzkKdx72bZ1aUri4xedhOHvtzxG3wpo775n2w2TN/jF27Hz0+lbLEY4
         oHKObMRWSyJ1Q==
Date:   Fri, 17 Mar 2023 16:31:22 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Petr Mladek <pmladek@suse.com>, Song Liu <song@kernel.org>,
        patches@lists.linux.dev, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: mod->klp set on copy ok ?
Message-ID: <20230317233122.4vsewgrb3nq574fs@treble>
References: <CAB=NE6Vo4AXVrn1GPEoZWVF3NkXRoPwWOuUEJqJ35S9VMGTM2Q@mail.gmail.com>
 <ZA8NBuXbVP+PRPp0@alley>
 <ZBOPP4YWWhJRk2yn@bombadil.infradead.org>
 <20230317161639.3de7yeek6ia4y7ul@treble>
 <ZBS42Lid+CX0h0fk@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZBS42Lid+CX0h0fk@bombadil.infradead.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Mar 17, 2023 at 12:00:40PM -0700, Luis Chamberlain wrote:
> > I dug into that code years ago, and the above sounds right.
> > 
> > The .ko file has a .gnu.linkonce.this_module section whose data is just
> > the original "struct module __this_module" which is created by the
> > module build (from foo.mod.c).
> > 
> > At the beginning of the finit_module() syscall, the .ko file's ELF
> > sections get copied (and optionally decompressed) into kernel memory.
> > Then 'mod' just points to the copied __this_module struct.
> > 
> > Then mod->klp (and possibly mod->taint) get set.
> > 
> > Then in layout_and_allocate(), that 'mod' gets memcpy'd into the second
> > (and final) in-kernel copy of 'struct module':
> > 
> >  		if (shdr->sh_type != SHT_NOBITS)
> >  			memcpy(dest, (void *)shdr->sh_addr, shdr->sh_size);
> >  		/* Update sh_addr to point to copy in image. */
> >  		shdr->sh_addr = (unsigned long)dest;
> > 
> > I suspect you don't see the size changing when you add to 'struct
> > module' because it's ____cacheline_aligned.
> > 
> > It's all rather obtuse, but working as designed as far as I can tell.
> 
> Ah, well it is beyond a ____cacheline_aligned issue! It would seem our build
> system does not incur a full re-build of $foo.mod.c if the size of struct module
> changes. Doing a full rebuild does get the right drift size change in
> struct module:

Ah, ok.  It sounds like build dependencies are broken for *.mod.c.

The added validations in the patch look reasonable, though the broken
build dependencies should also get fixed.

-- 
Josh
