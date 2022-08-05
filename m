Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 407D858B0F9
	for <lists+live-patching@lfdr.de>; Fri,  5 Aug 2022 22:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240307AbiHEU6P (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 5 Aug 2022 16:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240175AbiHEU6O (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 5 Aug 2022 16:58:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C951916598
        for <live-patching@vger.kernel.org>; Fri,  5 Aug 2022 13:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659733092;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PqBJYKESdHRUYaohT/lDIUbyIoy2GPwbn7JGBZzI4GY=;
        b=MUGcusONzMzQalokPslU5Q8IEbmiMqfQ9z35EkerCXumZDAaJL+4dvPMsQMSEUlE8p5duq
        Fa+VMAb0QzOc9Q5qz9K2STXe8ymH7r9UVHb8N4Ks3BMAnz0i+R7RhKbB8xbjcEF8I1PORS
        IQlD1HsgMb62FD8jW3KyDd+dvruHTks=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-232-aRtC_ZOAPgerbvKnmUIezQ-1; Fri, 05 Aug 2022 16:58:11 -0400
X-MC-Unique: aRtC_ZOAPgerbvKnmUIezQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E80A7803520;
        Fri,  5 Aug 2022 20:58:10 +0000 (UTC)
Received: from redhat.com (unknown [10.22.33.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 301B71121314;
        Fri,  5 Aug 2022 20:58:10 +0000 (UTC)
Date:   Fri, 5 Aug 2022 16:58:08 -0400
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Song Liu <song@kernel.org>
Cc:     live-patching@vger.kernel.org, jpoimboe@kernel.org,
        jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com,
        kernel-team@fb.com, Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v4] livepatch: Clear relocation targets on a module
 removal
Message-ID: <Yu2EYG0YjPLjiPk0@redhat.com>
References: <20220801212129.2008177-1-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220801212129.2008177-1-song@kernel.org>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Aug 01, 2022 at 02:21:29PM -0700, Song Liu wrote:
> From: Miroslav Benes <mbenes@suse.cz>
> 
> Josh reported a bug:
> 
>   When the object to be patched is a module, and that module is
>   rmmod'ed and reloaded, it fails to load with:
> 
>   module: x86/modules: Skipping invalid relocation target, existing value is nonzero for type 2, loc 00000000ba0302e9, val ffffffffa03e293c
>   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
>   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
> 
>   The livepatch module has a relocation which references a symbol
>   in the _previous_ loading of nfsd. When apply_relocate_add()
>   tries to replace the old relocation with a new one, it sees that
>   the previous one is nonzero and it errors out.
> 
>   On ppc64le, we have a similar issue:
> 
>   module_64: livepatch_nfsd: Expected nop after call, got e8410018 at e_show+0x60/0x548 [livepatch_nfsd]
>   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
>   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
> 
> He also proposed three different solutions. We could remove the error
> check in apply_relocate_add() introduced by commit eda9cec4c9a1
> ("x86/module: Detect and skip invalid relocations"). However the check
> is useful for detecting corrupted modules.
> 
> We could also deny the patched modules to be removed. If it proved to be
> a major drawback for users, we could still implement a different
> approach. The solution would also complicate the existing code a lot.
> 
> We thus decided to reverse the relocation patching (clear all relocation
> targets on x86_64). The solution is not
> universal and is too much arch-specific, but it may prove to be simpler
> in the end.
> 
> Reported-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Signed-off-by: Miroslav Benes <mbenes@suse.cz>
> Signed-off-by: Song Liu <song@kernel.org>
> 
> ---
> 
> NOTE: powerpc code has not be tested.
> 

Hi Song,

I just want to provide a quick check in on this patch...

First -- what tree / commit should this be based on?  When I add this
patch on top of a v5.19 based tree, I see:

arch/powerpc/kernel/module_64.c: In function ‘clear_relocate_add’:
arch/powerpc/kernel/module_64.c:781:52: error: incompatible type for argument 1 of ‘instr_is_relative_link_branch’
  781 |                 if (!instr_is_relative_link_branch(*instruction))
      |                                                    ^~~~~~~~~~~~
      |                                                    |
      |                                                    u32 {aka unsigned int}
In file included from arch/powerpc/kernel/module_64.c:20:
./arch/powerpc/include/asm/code-patching.h:122:46: note: expected ‘ppc_inst_t’ but argument is of type ‘u32’ {aka ‘unsigned int’}
  122 | int instr_is_relative_link_branch(ppc_inst_t instr);
      |                                   ~~~~~~~~~~~^~~~~
arch/powerpc/kernel/module_64.c:785:32: error: ‘PPC_INST_NOP’ undeclared (first use in this function); did you mean ‘PPC_INST_COPY’?
  785 |                 *instruction = PPC_INST_NOP;
      |                                ^~~~~~~~~~~~
      |                                PPC_INST_COPY
arch/powerpc/kernel/module_64.c:785:32: note: each undeclared identifier is reported only once for each function it appears in
make[2]: *** [scripts/Makefile.build:249: arch/powerpc/kernel/module_64.o] Error 1
make[1]: *** [scripts/Makefile.build:466: arch/powerpc/kernel] Error 2
make: *** [Makefile:1849: arch/powerpc] Error 2


Second, I rebased the klp-convert-tree on top of v5.19 here:
https://github.com/joe-lawrence/klp-convert-tree/tree/klp-convert-v7-devel

and I can confirm that at least the x86_64 livepatching selftests
(including the klp-relocation tests added by this tree) do pass.  I
haven't had a chance to try writing new tests to verify this specific
patch, but I'll take a look next week.

Regards,

--
Joe

