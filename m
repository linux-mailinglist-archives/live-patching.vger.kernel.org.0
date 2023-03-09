Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E99A6B20C4
	for <lists+live-patching@lfdr.de>; Thu,  9 Mar 2023 10:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbjCIJ6H (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 9 Mar 2023 04:58:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbjCIJ6F (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 9 Mar 2023 04:58:05 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E4441C596
        for <live-patching@vger.kernel.org>; Thu,  9 Mar 2023 01:58:04 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 07AD81FFD8;
        Thu,  9 Mar 2023 09:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1678355883; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rSH6AK+rX0k10XErmNzYqt+5wplGCSLmBIRJyOGe0vQ=;
        b=DmAdu99aCzvIc8B/Z+suHSEcmddLCwvzTYVSKxtJpAYF2r0y+IpMNd7J78pGvROY7pmsgB
        ZZXUYogInyMOIpQ/Xtxws/iJ+P8YwZVkVQzhCuakm6Sp5DNapcaUPpZVoUQ8eidjzAY3qs
        7q0T7qQtFbswFfjeAXGakIfz00MtF8g=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id A68072C141;
        Thu,  9 Mar 2023 09:58:02 +0000 (UTC)
Date:   Thu, 9 Mar 2023 10:58:01 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Alexey Dobriyan <adobriyan@gmail.com>
Cc:     jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
        joe.lawrence@redhat.com, live-patching@vger.kernel.org
Subject: Re: [PATCH] livepatch: fix ELF typos
Message-ID: <ZAmtqWVgBEJIXRcE@alley>
References: <Y/3vWjQ/SBA5a0i5@p183>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/3vWjQ/SBA5a0i5@p183>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue 2023-02-28 15:11:06, Alexey Dobriyan wrote:
> ELF is acronym.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

JFYI, the patch has been committed into livepatching.git,
branch for-6.4/doc.

Best Regards,
Petr
