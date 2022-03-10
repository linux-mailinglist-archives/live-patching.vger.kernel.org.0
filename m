Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8334D429A
	for <lists+live-patching@lfdr.de>; Thu, 10 Mar 2022 09:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240256AbiCJIeo (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 10 Mar 2022 03:34:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240384AbiCJIei (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 10 Mar 2022 03:34:38 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DDA062A0F;
        Thu, 10 Mar 2022 00:33:38 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id A74FB1F442;
        Thu, 10 Mar 2022 08:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1646901216; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3XKssLMVaaKPGr1fYyg9OX0U/rmkH9hiuCc6zH77j7Q=;
        b=qojACQbACPKHg2O88Oh8MesyQEqAzw2krjz++XlOmWBvRAdlLq71H+D6n42CSkFFy71Lu6
        TKSYmeJELupVwXybOOVVyMl6HNN/OvirvKDl5t9ZFstRSxR1aVQtw9zu9HEwPKN7jsH0am
        NjqzGuhTZsBzL5pKn2XPVGIyzOl4IBE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1646901216;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3XKssLMVaaKPGr1fYyg9OX0U/rmkH9hiuCc6zH77j7Q=;
        b=/vDGK3s1A+NR9R9SPCaWsAPotrf+zvh7Blknz3wmt/QtfHAvD0wNfEedhH5hL25CG3CWtc
        eKqwRkVjWoMlODAg==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 5780FA3B83;
        Thu, 10 Mar 2022 08:33:36 +0000 (UTC)
Date:   Thu, 10 Mar 2022 09:33:36 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Mark Brown <broonie@kernel.org>
cc:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
        Mark Rutland <mark.rutland@arm.com>, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v13 06/11] arm64: Use stack_trace_consume_fn and rename
 args to unwind()
In-Reply-To: <YiiT2lFuxc3ob+Zq@sirena.org.uk>
Message-ID: <alpine.LSU.2.21.2203100923470.16704@pobox.suse.cz>
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f> <20220117145608.6781-1-madvenka@linux.microsoft.com> <20220117145608.6781-7-madvenka@linux.microsoft.com> <YgutJKqYe8ss8LLd@FVFF77S0Q05N> <845e4589-97d9-5371-3a0e-f6e05919f32d@linux.microsoft.com>
 <YiY6hecX0pVWowQ7@sirena.org.uk> <c494fa10-e973-c137-b637-66bde327611c@linux.microsoft.com> <YiiT2lFuxc3ob+Zq@sirena.org.uk>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 9 Mar 2022, Mark Brown wrote:

> On Tue, Mar 08, 2022 at 04:00:35PM -0600, Madhavan T. Venkataraman wrote:
> 
> > It is just that patch 11 that defines "select
> > HAVE_RELIABLE_STACKTRACE" did not receive any comments from you
> > (unless I missed a comment that came from you. That is entirely
> > possible. If I missed it, my bad). Since you suggested that change, I
> > just wanted to make sure that that patch looks OK to you.
> 
> I think that's more a question for the livepatch people to be honest -
> it's not entirely a technical one, there's a bunch of confidence level
> stuff going on.  For example there was some suggestion that people might
> insist on having objtool support, though there's also substantial
> pushback on making objtool a requirement for anything from other
> quarters.  I was hoping that posting that patch would provoke some
> discussion about what exactly is needed but that's not happened thus
> far.

I think everyone will be happy with HAVE_RELIABLE_STACKTRACE on arm64 as 
long as there is a guarantee that stack traces are really reliable. My 
understanding is that there is still some work to be done on arm64 arch 
side (but I may have misunderstood what Mark R. said elsewhere). And yes, 
then there is a question of objtool. It is one option but not the only 
one. There have been proposals of implementing guarantees on a compiler 
side and leaving objtool for x86_64 only (albeit objtool may bring more 
features to the table... ORC, arch features checking).

Madhavan also mentioned that he enhanced objtool and he planned to submit 
it eventually 
(https://lore.kernel.org/all/1a0e19db-a7f8-4c8e-0163-398fcd364d54@linux.microsoft.com/T/#u), 
so maybe arm64 maintainers could decide on a future direction based on 
that?

Regards
Miroslav

