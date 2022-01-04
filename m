Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6159748421E
	for <lists+live-patching@lfdr.de>; Tue,  4 Jan 2022 14:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233322AbiADNJE (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 4 Jan 2022 08:09:04 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:36168 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiADNJD (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 4 Jan 2022 08:09:03 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id CB76B1F37F;
        Tue,  4 Jan 2022 13:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1641301742; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QzgcpTNiBUmfwXnzGEhmPrP9Mo+srsFroAQ2OAHiqOM=;
        b=ondmDVqgk178Mgeb6ilSxVBfsPDz9FuV0qmBaGAGbJzkB0jWNBQI4zoS7VM2eaVPUFvfAE
        LLasJ4Se2LMyItctDd92o4g6pCC7lbKXQSP0+2VwYvt/cS2tP6lS2+X+PfWdWnykOiYo+3
        Hf6OZecB+Nad2ObkQDrKl9l7RaK8niA=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id AA677A3B83;
        Tue,  4 Jan 2022 13:09:02 +0000 (UTC)
Date:   Tue, 4 Jan 2022 14:09:02 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        void@manifault.com
Subject: Re: [PATCH -next] livepatch: Fix missing unlock on error in
 klp_enable_patch()
Message-ID: <YdRG7oSUICq+Y+gE@alley>
References: <20211225025115.475348-1-yangyingliang@huawei.com>
 <YdL+QdAv3MtRSKJy@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YdL+QdAv3MtRSKJy@alley>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon 2022-01-03 14:46:42, Petr Mladek wrote:
> On Sat 2021-12-25 10:51:15, Yang Yingliang wrote:
> > Add missing unlock when try_module_get() fails in klp_enable_patch().
> > 
> > Fixes: bf01c2975925 ("livepatch: Fix kobject refcount bug on klp_init_patch_early failure path")
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> 
> JFYI, the patch has been committed into livepatch.git,
> branch for-5.17/fixes.

Just for record. I had to rebase the branch for-5.17/fixes because of
missing Signed-off. I have updated Fixes: line to match the hash
of the rebased commit. I hope that this fixed all my pre-holidays
mistakes.

Best Regards,
Petr
