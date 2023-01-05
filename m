Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C395465F175
	for <lists+live-patching@lfdr.de>; Thu,  5 Jan 2023 17:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234002AbjAEQxU (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 5 Jan 2023 11:53:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233993AbjAEQxT (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 5 Jan 2023 11:53:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C97116A
        for <live-patching@vger.kernel.org>; Thu,  5 Jan 2023 08:53:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F297B81B49
        for <live-patching@vger.kernel.org>; Thu,  5 Jan 2023 16:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECBF2C433F1
        for <live-patching@vger.kernel.org>; Thu,  5 Jan 2023 16:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672937596;
        bh=LYXCtP6tjYvNt+gp9S5tH2JimG3HmRYyAEpGqMI0XXE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=IIykAEIdA5aAf21/9aUNfWeaoN82HnrVEmMP2r0cJ3aeJl/lLupUO4zIIavwweVfK
         L0doPuKN/1cksxwr2nUIO11DgMI7iYsDnsJ6C6tUSf5yz4Zd7KnxpcpDNDDu3EetuT
         72xp3NXPdeJIS8yGkH0rBPVRZW2x0cTwuHR8uOhDxAOQ48BT9Qk2rEgJndqyNGEo/k
         4CazveTU+RlOXZHpcnt6KZkEB8B9vt+ayjXKdUYajPIThfzWq8BQeaytp4dIwLw1FA
         IQ8Dt5IQKgCYiH6D7Wmdxdv2N7sQVtAYUL9VWQaftAIWyfS4NQktOLI6C2JfPhPyj3
         P/a9nMehoNIww==
Received: by mail-lf1-f47.google.com with SMTP id cf42so55808658lfb.1
        for <live-patching@vger.kernel.org>; Thu, 05 Jan 2023 08:53:15 -0800 (PST)
X-Gm-Message-State: AFqh2kpwEHUSRb6zJWrvqjHWTTR9z/Z6gcc+1YaEccPHUkZ8nsgsLNwj
        3ctjYPreCg35Uo0cgtiSK0/bpwuH+CacPcTnsME=
X-Google-Smtp-Source: AMrXdXvPT9rRA/nlec8AES3ETZAEvhwSmDdBtLMB+QqsQbaIwhmuXlWHeVKlKoSqBEcemkwJhu1/9zKLsG3Hy7d1SoE=
X-Received: by 2002:ac2:4a8d:0:b0:4a2:4282:89c7 with SMTP id
 l13-20020ac24a8d000000b004a2428289c7mr3779128lfp.437.1672937593976; Thu, 05
 Jan 2023 08:53:13 -0800 (PST)
MIME-Version: 1.0
References: <20221214174035.1012183-1-song@kernel.org> <Y7VUPAEFFFougaoC@alley>
 <CAPhsuW7EAFgUUgh3Q6wbE-PNLGnSFFWmdQaYfOqVW6adM0+G4g@mail.gmail.com> <Y7ayTvpxnDvX9Nfi@alley>
In-Reply-To: <Y7ayTvpxnDvX9Nfi@alley>
From:   Song Liu <song@kernel.org>
Date:   Thu, 5 Jan 2023 08:53:01 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5E9m5tb_ZCknH4QfFMukqwZHkKxvkHxo5A-znt5tm0ow@mail.gmail.com>
Message-ID: <CAPhsuW5E9m5tb_ZCknH4QfFMukqwZHkKxvkHxo5A-znt5tm0ow@mail.gmail.com>
Subject: Re: [PATCH v7] livepatch: Clear relocation targets on a module removal
To:     Petr Mladek <pmladek@suse.com>
Cc:     live-patching@vger.kernel.org, jpoimboe@kernel.org,
        jikos@kernel.org, joe.lawrence@redhat.com,
        Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Jan 5, 2023 at 3:20 AM Petr Mladek <pmladek@suse.com> wrote:
[...]
>
> The ideal solution would be to add checks into apply_relocated_add().
> It would make it more robust. In that case, clear_relocated_add()
> would need to clear everything.
>
> But this is not the case on powerpc and s390 at the moment.
> In this case, I suggest to clear only relocations that
> are checked in apply_relocated_add().
>
> But it should be done without duplicating the code.
>
> It would actually make sense to compute the value that was
> used in apply_relocated_add() and check that we are clearing
> the value. If we try to clear some other value than we
> probably do something wrong.
>
> This might actually be a solution. We could compute
> the value in both situations. Then we could have
> a common function for writing.
>
> This write function would check that it replaces zero
> with the value in apply_relocate_add() and that it replaces
> the value with zero in clear_relocate_add().

I like this idea. But I am not quite sure whether we can do it
for all those complicated cases.

Btw: I am confused with this one:

                case R_PPC64_REL16_HA:
                        /* Subtract location pointer */
                        value -= (unsigned long)location;
                        value = ((value + 0x8000) >> 16);
                        *((uint16_t *) location)
                                = (*((uint16_t *) location) & ~0xffff)
                                | (value & 0xffff);
                        break;

(*((uint16_t *) location) & ~0xffff) should always be zero, no?

Thanks,
Song
