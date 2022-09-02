Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B59515AADE3
	for <lists+live-patching@lfdr.de>; Fri,  2 Sep 2022 13:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiIBLuC (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 2 Sep 2022 07:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235042AbiIBLt7 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 2 Sep 2022 07:49:59 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A810FFD15
        for <live-patching@vger.kernel.org>; Fri,  2 Sep 2022 04:49:57 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id E2D645BD5F;
        Fri,  2 Sep 2022 11:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1662119395; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FXPJdqOyhW/VAo8Xaa3HJiUKRsBvn1Q/jtvDdQ2KLB0=;
        b=XrG5RLjggc29pRs7phQl0YEzMwB/JKzvyr0B2iDX54jZjrMdLQIFi4/zWbeS3awY+SnBHn
        OY5j9HrC3JPHRHLC5RqAGYyGGi4OL8MVh60BVqbiC6nDmN/oWVrInYVfcmib4NSYQdl9g1
        wqTqCAko7MzNPnRHkm3y+Tg6a0SZQ6c=
Received: from suse.cz (pathway.suse.cz [10.100.12.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id A680E2C141;
        Fri,  2 Sep 2022 11:49:55 +0000 (UTC)
Date:   Fri, 2 Sep 2022 13:49:55 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Song Liu <song@kernel.org>
Cc:     live-patching@vger.kernel.org, jpoimboe@kernel.org,
        jikos@kernel.org, mbenes@suse.cz, joe.lawrence@redhat.com,
        kernel-team@fb.com
Subject: Re: [PATCH v2 1/2] livepatch: add sysfs entry "patched" for each
 klp_object
Message-ID: <20220902114955.GA25533@pathway.suse.cz>
References: <20220802010857.3574103-1-song@kernel.org>
 <20220802010857.3574103-2-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220802010857.3574103-2-song@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon 2022-08-01 18:08:56, Song Liu wrote:
> Add per klp_object sysfs entry "patched". It makes it easier to debug
> typos in the module name.
> 
> Signed-off-by: Song Liu <song@kernel.org>

Looks good to me:

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
