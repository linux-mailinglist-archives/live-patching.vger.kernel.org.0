Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF4434DB3DE
	for <lists+live-patching@lfdr.de>; Wed, 16 Mar 2022 16:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344834AbiCPPFQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 16 Mar 2022 11:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243630AbiCPPFO (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 16 Mar 2022 11:05:14 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7457317A8B;
        Wed, 16 Mar 2022 08:03:56 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 296301F38A;
        Wed, 16 Mar 2022 15:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1647443035; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6gilQw/9Z9NczvnlsL52W9+TUtbcnnLp4l+WuiFISy8=;
        b=wCo8gk2HPzBD7T7oH5WtYhIza+sErb1GQTspR2PpAw7fmk2uHICAC1F/xQd3y80qM2dpqz
        ORZCuW4Cs83nnxLPBpR78R5mXuL3+S+nOqcUn07kB9XVDhGOcVGeu8bP1/kEenVPj+HXJO
        8qzh1zis8br4r5v17Bs2ftByomDP8aM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1647443035;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6gilQw/9Z9NczvnlsL52W9+TUtbcnnLp4l+WuiFISy8=;
        b=HxpnJAtx1yaQPrpnCGnH28tQVTAAkmB9FWOpuOi6gKMERe1RD6Va/qUM21euQqy7G6i2hD
        eJSZGLDUhCHza9Cg==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 011C9A3B87;
        Wed, 16 Mar 2022 15:03:54 +0000 (UTC)
Date:   Wed, 16 Mar 2022 16:03:54 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Petr Mladek <pmladek@suse.com>
cc:     Chengming Zhou <zhouchengming@bytedance.com>, jpoimboe@redhat.com,
        jikos@kernel.org, joe.lawrence@redhat.com,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        songmuchun@bytedance.com, qirui.001@bytedance.com
Subject: Re: [PATCH v3] livepatch: Don't block removal of patches that are
 safe to unload
In-Reply-To: <YjH7rniD4rBO6JIP@alley>
Message-ID: <alpine.LSU.2.21.2203161602490.6444@pobox.suse.cz>
References: <20220312152220.88127-1-zhouchengming@bytedance.com> <alpine.LSU.2.21.2203161536330.6444@pobox.suse.cz> <YjH7rniD4rBO6JIP@alley>
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

> > > + /*
> > > +	 * Only need to set forced flag for the transition patch
> > > +	 * when force transition to KLP_UNPATCHED state, but
> > > +	 * have to set forced flag for all replaced patches
> > > +	 * when force atomic replace transition.
> > > +	 */
> > 
> > How about something like
> > 
> > /*
> >  * Set forced flag for patches being removed, which is the transition
> >  * patch in KLP_UNPATCHED state or all replaced patches when forcing
> >  * the atomic replace transition.
> >  */
> 
> Or just the first sentence:
> 
> 	/* Set forced flag for patches being removed */
> 
> The rest is visible from the code.

True. This would work for me as well.

Miroslav
