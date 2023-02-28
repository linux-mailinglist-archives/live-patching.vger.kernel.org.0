Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6B66A5CB0
	for <lists+live-patching@lfdr.de>; Tue, 28 Feb 2023 17:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbjB1QBa (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 28 Feb 2023 11:01:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbjB1QB2 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 28 Feb 2023 11:01:28 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 347443251F
        for <live-patching@vger.kernel.org>; Tue, 28 Feb 2023 08:01:21 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id CE2931FDC6;
        Tue, 28 Feb 2023 16:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1677600079; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oJ5z0EVQ/hbVea2pZphIb4vuCRdWqIMR+1VK89gjhTk=;
        b=m4J00j+38BVw0IWReSpgitgB+2LtwA8aouQ184GPmQRX377YWJ2NtA9DukJElIIj96L6cH
        EyIa3IIdSePSjQUd/xG+/1+joQCNBZCn9UNkXcQsP6RjV6PocUx3hm6MCPVw4+FRfUduvD
        NyZhwieMr8qpG07L459+aRs5NeSYb+E=
Received: from suse.cz (pmladek.udp.ovpn2.prg.suse.de [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 7C2AA2C141;
        Tue, 28 Feb 2023 16:01:19 +0000 (UTC)
Date:   Tue, 28 Feb 2023 17:01:15 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Alexey Dobriyan <adobriyan@gmail.com>
Cc:     jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
        joe.lawrence@redhat.com, live-patching@vger.kernel.org
Subject: Re: [PATCH] livepatch: fix ELF typos
Message-ID: <Y/4lSxAZTNdIxPs1@alley>
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

Makes sense.

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
