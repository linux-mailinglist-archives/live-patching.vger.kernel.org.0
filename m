Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C386D68ADA8
	for <lists+live-patching@lfdr.de>; Sun,  5 Feb 2023 01:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbjBEAqY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 4 Feb 2023 19:46:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbjBEAqX (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 4 Feb 2023 19:46:23 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FACB206A9;
        Sat,  4 Feb 2023 16:46:21 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4P8W0k6xFTz4xG5;
        Sun,  5 Feb 2023 11:46:14 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1675557975;
        bh=tWd2oYs3tgpsmxYhQeNi8EKfkgW7lsYebdbamIWZmac=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=JhhDnLKVxNhgOzVNbYHPXACaRKUJ39/VvL7PF/2m2Z0VmB12QQ/mb4hVsBfbsxDZq
         5/YddJEuSWbLp7c9iu8N+/MTkg9VuJrFSN+L5LzhbEDO3RJkuOH329zwLga7oz42Xp
         kR0LwkzmD+RrbWSn4UafXrGItLrOEkZtO4wA9jy85RFotMy9WXotJ1DnRzR1rMd/7j
         kOMY2E3aUSaNWneTpEm1bBwM80+ETSb+Z00JUMzxMxlTLZG+NAPEfFIHuEI7VLKvOb
         iiHE2eDiKsneWen7lz4Am/LIUPKPFRzIrGtkyLm88TCDlzmN2TVLAvhWSVLwW8gMW/
         Pe4QAnuairozg==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     live-patching@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Song Liu <song@kernel.org>
Subject: Re: [PATCH 0/2] powerpc: Fix livepatch module re-patching issue
In-Reply-To: <20230204172357.mbudvbtv7tc7vhf3@treble>
References: <cover.1674617130.git.jpoimboe@kernel.org>
 <20230204172357.mbudvbtv7tc7vhf3@treble>
Date:   Sun, 05 Feb 2023 11:46:12 +1100
Message-ID: <87357ley7f.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Josh Poimboeuf <jpoimboe@kernel.org> writes:
> On Tue, Jan 24, 2023 at 07:38:03PM -0800, Josh Poimboeuf wrote:
>> Fix a livepatch bug seen when reloading a patched module.
>> 
>> This is the powerpc counterpart to Song Liu's fix for a similar issue on
>> x86:
>> 
>>   https://lkml.kernel.org/lkml/20230121004945.697003-2-song@kernel.org
>> 
>> Josh Poimboeuf (2):
>>   powerpc/module_64: Improve restore_r2() return semantics
>>   powerpc/module_64: Fix "expected nop" error on module re-patching
>> 
>>  arch/powerpc/kernel/module_64.c | 29 ++++++++++++++++++-----------
>>  1 file changed, 18 insertions(+), 11 deletions(-)
>
> Hi Michael,
>
> Ping?  Any objections to this?
>
> The x86 counterpart to this is queued for 6.3, it would be nice if this
> also landed.  We could take it through the livepatch tree if needed.

It's in my next since about a week. Sorry I forgot to send the
"accepted" emails (which I still don't have automated :/ ).

337251c7114e1 ("powerpc/module_64: Fix "expected nop" error on module re-patching")

cheers
