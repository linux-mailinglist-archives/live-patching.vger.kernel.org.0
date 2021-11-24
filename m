Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0992945B82F
	for <lists+live-patching@lfdr.de>; Wed, 24 Nov 2021 11:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240718AbhKXKUH (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 24 Nov 2021 05:20:07 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:34524 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232248AbhKXKUG (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 24 Nov 2021 05:20:06 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 289232193C;
        Wed, 24 Nov 2021 10:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1637749016; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KHN0YIQOgdz0zrhcq5D7cCO05rg7b04WTSkpUrhYoH4=;
        b=KyC9x1AeBJkNCcXNFesyZ1hGjCI44MuaGSEUPnNym9UxcKcTRt4Uq0Ix0w3EntRL3X6ZiH
        k5v9O5k16xuYSN29oG5ByMmjvzro8r3sWC4Z2gswj7gsdqfx1HMZYGZZuAarnxAzr7IBLp
        lpepnlLEzyG5qGh1zf8tuLW+AC+xH0c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1637749016;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KHN0YIQOgdz0zrhcq5D7cCO05rg7b04WTSkpUrhYoH4=;
        b=D0EVmj7PxRfq48BOIdaIOUqcwifkg86EmzwLUTcH1vBMA8Pag2FLAGI1LWB3Uz2PRirrOs
        9VM7QqLkP+QYNbAA==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 14591A3B85;
        Wed, 24 Nov 2021 10:16:56 +0000 (UTC)
Date:   Wed, 24 Nov 2021 11:16:55 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Joe Lawrence <joe.lawrence@redhat.com>
cc:     joao@overdrivepizza.com, nstange@suse.de, pmladek@suse.cz,
        Peter Zijlstra <peterz@infradead.org>, jpoimboe@redhat.com,
        live-patching@vger.kernel.org
Subject: Re: CET/IBT support and live-patches
In-Reply-To: <08d4a24d-02c2-6760-96bf-b72f51025808@redhat.com>
Message-ID: <alpine.LSU.2.21.2111241108270.19554@pobox.suse.cz>
References: <70828ca9f840960c7a3f66cd8dc141f5@overdrivepizza.com> <alpine.LSU.2.21.2111231035460.15177@pobox.suse.cz> <08d4a24d-02c2-6760-96bf-b72f51025808@redhat.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

> > Joe, what is the current state of klp-convert? Do we still want to follow 
> > that way?
> > 
> 
> kpatch-build relies on klp-relocations and they work well enough across
> the architectures we support.  Its code is slightly different than
> klp-convert, but concepts the same.  Moving all of that into the kernel
> build would definitely be better from a maintenance POV.

Ok, then it makes sense to me to pursue this.

> I can rebase the latest klp-convert patchset that I had worked on if we
> want to test and review.

Yes, please. I think we should take a fresher look and start working on it 
(again).

> Apologies for losing momentum on that patchset
> while waiting for .klp.arch stuff to drop out, in particular the subset
> of static key relocations would still be supported.

No need to apologize. Thank you for maintaining the patch set.

Miroslav
