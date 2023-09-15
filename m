Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE927A17EB
	for <lists+live-patching@lfdr.de>; Fri, 15 Sep 2023 10:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbjIOIDc (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 15 Sep 2023 04:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbjIOIDb (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 15 Sep 2023 04:03:31 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA292AC;
        Fri, 15 Sep 2023 01:03:25 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 9FAE1211C2;
        Fri, 15 Sep 2023 08:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1694765004; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZoNKSvuHoiHQrfpuE5e2rBpfL61aXV+uCk7xNtoZHoA=;
        b=zjFd5WDM27zM5tbs/aXZPdmgvBd8GEchyRrnHwlDuCJkjf7yFBuonndWyBDTzDT8sG1jQ8
        IrL9sNYA+t+url1amNeuH17uqwvI0FXLLBPDs3ig+5w3LuEkt4X8IF9M6KxQk7LHxuT+gH
        S7PAqnPEHzCCDX5P0ur8LkoPf6PcLH0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1694765004;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZoNKSvuHoiHQrfpuE5e2rBpfL61aXV+uCk7xNtoZHoA=;
        b=ih0A9rwoVEkU0XK/clJem075lRSqnfGNZkUoeOTX9yl0+2URSsoAUGD1ukZ5mZDAvD5hoI
        onuekGKvVv+GSmDg==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 49B0F2C142;
        Fri, 15 Sep 2023 08:03:23 +0000 (UTC)
Date:   Fri, 15 Sep 2023 10:03:23 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
cc:     joe.lawrence@redhat.com, jpoimboe@kernel.org, jikos@kernel.org,
        pmladek@suse.com, nstange@suse.de, mpdesouza@suse.de,
        mark.rutland@arm.com, broonie@kernel.org, ndesaulniers@google.com,
        miguel.ojeda.sandonis@gmail.com, elena.zannoni@oracle.com,
        indu.bhagat@oracle.com, peterz@infradead.org, jmorris@namei.org,
        rostedt@goodmis.org, songliubraving@meta.com,
        madvenka@linux.microsoft.com
Subject: Re: [ANNOUNCE and CfP] Live Patching MC at LPC 2023
In-Reply-To: <alpine.LSU.2.21.2308111057120.27256@pobox.suse.cz>
Message-ID: <alpine.LSU.2.21.2309151000560.30380@pobox.suse.cz>
References: <alpine.LSU.2.21.2306141313530.8054@pobox.suse.cz> <alpine.LSU.2.21.2308111057120.27256@pobox.suse.cz>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hello,

On Fri, 11 Aug 2023, Miroslav Benes wrote:

> Hi,
> 
> On Wed, 14 Jun 2023, Miroslav Benes wrote:
> 
> > Hello,
> > 
> > the Live Patching Microconference for Linux Plumbers Conference 2023 has 
> > been accepted.
> > 
> > It is possible to submit topic proposals and abstracts for the 
> > microconference through Indico system linked at [1]. I welcome you to do 
> > so. Submissions should then be published at [2].
> > 
> > The rest still remains to be sorted out. Joe and I will share information 
> > as it is available.
> > 
> > The registration will open soon [3].
> > 
> > See you in Richmond!
> > 
> > Miroslav
> > 
> > [1] https://lpc.events/event/17/abstracts/
> > [2] https://lpc.events/event/17/contributions/1405/
> > [3] https://lpc.events/blog/current/index.php/2023/06/14/registration-for-lpc-2023-is-almost-here/
> 
> Live Patching MC CfP blog post was published at 
> https://lpc.events/blog/current/index.php/2023/08/09/live-patching-mc-cfp/
> 
> Let me use the opportunity to also encourage you to submit topics for the 
> MC as mentioned above.

...and this is the last call. If you still want to submit a topic for the 
MC, please do so as soon as possible.

Thank you,
Miroslav
