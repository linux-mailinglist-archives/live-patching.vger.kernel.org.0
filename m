Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6040C64B131
	for <lists+live-patching@lfdr.de>; Tue, 13 Dec 2022 09:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234299AbiLMIbN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 13 Dec 2022 03:31:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234867AbiLMIas (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 13 Dec 2022 03:30:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E2D613F57;
        Tue, 13 Dec 2022 00:28:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2860B810AA;
        Tue, 13 Dec 2022 08:28:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8C3C433F2;
        Tue, 13 Dec 2022 08:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670920129;
        bh=biF+eTAkqIF3JO1B3nBjssgb0I7rUJZqnOdeA52gK48=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=QrK3NRELFIITs1X8Gw7MJg3X3dF0hB/xwQREu98b7mfLZPkM3w/fUW8HrhBM12OCI
         GXkSMuybgH9ndTcCMbkOagzkLXcm68Utxdt8TSo8LK7L6ynXowVoOWC7sXlu0l2hQN
         PmDCk2wFybWtlwlhiLu81x0unvD7yNaMPWyT/q1+dv1tN5vEf+O19ybixDuf03lel/
         L0Fx7j+41aEDox76It7LB58bRCXSlUJKHu72Tr2wj4kTWm8EfDgOMdeo8NznA8yxZu
         8rLhKvL9nsrks5imK16kbsGH6L+BtOPC0dIk8zeOctmy3wGffCt+4S6kBf5vC4d+D+
         5fR++QaSixYiQ==
Received: by mail-ej1-f47.google.com with SMTP id x22so34658881ejs.11;
        Tue, 13 Dec 2022 00:28:49 -0800 (PST)
X-Gm-Message-State: ANoB5pmH49akZC9SZqpbl5GkTnq/u6E4uaSWLtqwq5OL+V+cyLYLW4h/
        MnLplb62DEEoQuVN3HWMABOeOQqi/9KlYE4ENxo=
X-Google-Smtp-Source: AA0mqf4vJcEo1LSRY4RhLmFU2YbQkyl5LsUhYjyJyozawpCFk4qzUpBunnKcYc+d3Bkt4qORmVm+XeLuIBwoCK+0dLg=
X-Received: by 2002:a17:906:a198:b0:7b4:bc42:3b44 with SMTP id
 s24-20020a170906a19800b007b4bc423b44mr75084269ejy.101.1670920127837; Tue, 13
 Dec 2022 00:28:47 -0800 (PST)
MIME-Version: 1.0
References: <20220901171252.2148348-1-song@kernel.org> <alpine.LSU.2.21.2212091352370.18933@pobox.suse.cz>
In-Reply-To: <alpine.LSU.2.21.2212091352370.18933@pobox.suse.cz>
From:   Song Liu <song@kernel.org>
Date:   Tue, 13 Dec 2022 00:28:34 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5xb2T5FBXUqG2S+AXBvDYSkLVVvUyDamjrbLQwe-3kVQ@mail.gmail.com>
Message-ID: <CAPhsuW5xb2T5FBXUqG2S+AXBvDYSkLVVvUyDamjrbLQwe-3kVQ@mail.gmail.com>
Subject: Re: [PATCH v6] livepatch: Clear relocation targets on a module removal
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@kernel.org, jikos@kernel.org, pmladek@suse.com,
        x86@kernel.org, joe.lawrence@redhat.com,
        linuxppc-dev@lists.ozlabs.org, Josh Poimboeuf <jpoimboe@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Dec 9, 2022 at 4:55 AM Miroslav Benes <mbenes@suse.cz> wrote:
>
> Hi,
>
> first thank you for taking over and I also appologize for not replying
> much sooner.
>
> On Thu, 1 Sep 2022, Song Liu wrote:
>
> > From: Miroslav Benes <mbenes@suse.cz>
> >
> > Josh reported a bug:
> >
> >   When the object to be patched is a module, and that module is
> >   rmmod'ed and reloaded, it fails to load with:
> >
> >   module: x86/modules: Skipping invalid relocation target, existing value is nonzero for type 2, loc 00000000ba0302e9, val ffffffffa03e293c
> >   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
> >   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
> >
> >   The livepatch module has a relocation which references a symbol
> >   in the _previous_ loading of nfsd. When apply_relocate_add()
> >   tries to replace the old relocation with a new one, it sees that
> >   the previous one is nonzero and it errors out.
> >
> >   On ppc64le, we have a similar issue:
> >
> >   module_64: livepatch_nfsd: Expected nop after call, got e8410018 at e_show+0x60/0x548 [livepatch_nfsd]
> >   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
> >   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
> >
> > He also proposed three different solutions. We could remove the error
> > check in apply_relocate_add() introduced by commit eda9cec4c9a1
> > ("x86/module: Detect and skip invalid relocations"). However the check
> > is useful for detecting corrupted modules.
> >
> > We could also deny the patched modules to be removed. If it proved to be
> > a major drawback for users, we could still implement a different
> > approach. The solution would also complicate the existing code a lot.
> >
> > We thus decided to reverse the relocation patching (clear all relocation
> > targets on x86_64). The solution is not
> > universal and is too much arch-specific, but it may prove to be simpler
> > in the end.
> >
> > Reported-by: Josh Poimboeuf <jpoimboe@redhat.com>
> > Signed-off-by: Miroslav Benes <mbenes@suse.cz>
> > Signed-off-by: Song Liu <song@kernel.org>
>
> Petr has commented on the code aspects. I will just add that s390x was not
> dealt with at the time because there was no live patching support for
> s390x back then if I remember correctly and my notes do not lie. The same
> applies to powerpc32. I think that both should be fixed as well with this
> patch. It might also help to clean up the ifdeffery in the patch a bit.

After reading the code (no testing), I think we don't need any logic for
ppc32 and s390.

We need clear_relocate_add() to handle module reload failure.
The failure happens when we

1) call apply_relocate_add() on klp load (or module first load,
   if klp was loaded first);
2) do nothing when the module is unloaded;
3) call apply_relocate_add() on module reload, which failed.

This failure happens in the sanity check in
apply_relocate_add().

For x86, the check is something like:
                                if (*(s32 *)loc != 0)
                                        goto invalid_relocation;

For ppc64, the check is in restore_r2():

        if (*instruction != PPC_RAW_NOP()) {
                pr_err("%s: Expected nop after call, got %08x at %pS\n",
                        me->name, *instruction, instruction);
                return 0;
        }

I don't think we have similar checks for ppc32 and s390, so
clear_relocate_add() is not needed for the two.

OTOH, we can argue that clear_relocate_add() should undo
everything apply_relocate_add() did. But I do think that
will be an overkill.

WDYT?

Thanks,
Song
