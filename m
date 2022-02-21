Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCDE4BE4A3
	for <lists+live-patching@lfdr.de>; Mon, 21 Feb 2022 18:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244138AbiBUMsQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 21 Feb 2022 07:48:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358285AbiBUMsP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 21 Feb 2022 07:48:15 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA0E19C1E;
        Mon, 21 Feb 2022 04:47:51 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 98A1F1F38E;
        Mon, 21 Feb 2022 12:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1645447670; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ggDr+neVaJjQk+RK8hUolcl9uVy87We72St6yVLaZrY=;
        b=TjqKpOoNnm2SrZFGeO61o7QMq6ifBmqWqgv5aw+qRbTKhUJ/qC8lsDmxWWCp68unRMO1nP
        Y+3xlZlNpXn13UHDCJz3anaKq09NLRxMRvlcSsi4FvpsHVU87EhG1A5J12yWI515/O3n1F
        ffyzK3joF0qIVp52841wc5oqq2udgwY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1645447670;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ggDr+neVaJjQk+RK8hUolcl9uVy87We72St6yVLaZrY=;
        b=/bKjaUPAPW/eyKPpIlcpFXZoxlW5kgclr17AyaDktOhhzWEASwZOfLOR2wtLbqh9QL6W9u
        r5682tWLeuW23lCw==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 50B5CA3B8D;
        Mon, 21 Feb 2022 12:47:50 +0000 (UTC)
Date:   Mon, 21 Feb 2022 13:47:50 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Luis Chamberlain <mcgrof@kernel.org>
cc:     Aaron Tomlin <atomlin@redhat.com>, cl@linux.com, pmladek@suse.com,
        akpm@linux-foundation.org, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, atomlin@atomlin.com,
        ghalat@redhat.com, allen.lkml@gmail.com, joe@perches.com,
        christophe.leroy@csgroup.eu, msuchanek@suse.de,
        oleksandr@natalenko.name
Subject: Re: [PATCH v6 00/13] module: core code clean up
In-Reply-To: <YhBSBzmuiDQ4yMER@bombadil.infradead.org>
Message-ID: <alpine.LSU.2.21.2202211347050.22887@pobox.suse.cz>
References: <20220218212511.887059-1-atomlin@redhat.com> <YhBSBzmuiDQ4yMER@bombadil.infradead.org>
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

On Fri, 18 Feb 2022, Luis Chamberlain wrote:

> On Fri, Feb 18, 2022 at 09:24:58PM +0000, Aaron Tomlin wrote:
> > Hi Luis,
> > 
> > As per your suggestion [1], this is an attempt to refactor and split
> > optional code out of core module support code into separate components.
> > This version is based on Linus' commit 7993e65fdd0f ("Merge tag
> > 'mtd/fixes-for-5.17-rc5' of
> > git://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux").
> > Please let me know your thoughts.
> 
> Fantastic, thanks for doing all this work, I've pushed this out to
> modules-next so that the testing can start as this will be in linux-next
> soon. I'll obviously wait for more reviews, we have a long time before this
> gets merged to Linus, so just want to start getting testing done now rather
> than later. And other folks are depending on your changes to start
> getting their own code up too.

Aaron's series is unfortunately split. Could you also push out the 
remaining 3 patches (20220218212757.888751-1-atomlin@redhat.com), please?

Miroslav
