Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4FA47A7706
	for <lists+live-patching@lfdr.de>; Wed, 20 Sep 2023 11:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233753AbjITJRc (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 20 Sep 2023 05:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbjITJRa (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 20 Sep 2023 05:17:30 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598BB93;
        Wed, 20 Sep 2023 02:17:24 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 18F481FE5A;
        Wed, 20 Sep 2023 09:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1695201443; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=27wI1sJ0W7FVqiafMukx5GHlCjweHRT5QdRGpq+Xpj4=;
        b=ltBrVNxJVyHNQlquXEA+Hh07m+uqUVjLEEMJAwzXX5Nx/z2bqzy2Uu0y7moLco66mSEJjP
        7PqOnFt6ioZhafT+HrkyQpqTP09zAQ8EnJibjH+q2LYmMm+Y6a9Rw6aI5HOaJckFB8qipy
        FxnwP9sROYS2BnJZkoTzMp3yPoxF7sA=
Received: from suse.cz (pmladek.tcp.ovpn2.prg.suse.de [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id DBEBD2C142;
        Wed, 20 Sep 2023 09:17:22 +0000 (UTC)
Date:   Wed, 20 Sep 2023 11:17:22 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Zheng Yejian <zhengyejian1@huawei.com>
Cc:     jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
        joe.lawrence@redhat.com, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        yeweihua4@huawei.com
Subject: Re: [PATCH] livepatch: Fix missing newline character in
 klp_resolve_symbols()
Message-ID: <ZQq4oo2i-dZZPt4D@alley>
References: <20230914072644.4098857-1-zhengyejian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230914072644.4098857-1-zhengyejian1@huawei.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2023-09-14 15:26:44, Zheng Yejian wrote:
> Without the newline character, the log may not be printed immediately
> after the error occurs.
> 
> Fixes: ca376a937486 ("livepatch: Prevent module-specific KLP rela sections from referencing vmlinux symbols")
> Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
