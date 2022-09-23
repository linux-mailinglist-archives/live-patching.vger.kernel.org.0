Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE2BE5E7DCA
	for <lists+live-patching@lfdr.de>; Fri, 23 Sep 2022 16:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbiIWO7P (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 23 Sep 2022 10:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231994AbiIWO7J (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 23 Sep 2022 10:59:09 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50944127544;
        Fri, 23 Sep 2022 07:59:08 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id F2BF821A36;
        Fri, 23 Sep 2022 14:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1663945147; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=v/Njrnx0kAmVnJjPWQHDdXR2gNpBPDEtnzydYSQrI84=;
        b=sW9bUnodCUG+/g3Ybi/AfoW6DBuUeCelx5TiOHT2FMTk7UtCcJUxnbWlaJj3E45DhK2riv
        1ie1uogLPZO/buKX1xJC+5SSm8nvaGqTDRr9AShCL/KN99QEXj+k5WeXtdqfX2m2vEXy8S
        /Zy2Wj6PJvGaK/Fxeh6qccXvuRStIFo=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id D27FA2C15A;
        Fri, 23 Sep 2022 14:59:06 +0000 (UTC)
Date:   Fri, 23 Sep 2022 16:59:06 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Song Liu <song@kernel.org>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
        joe.lawrence@redhat.com
Subject: Re: [PATCH v3 1/2] livepatch: add sysfs entry "patched" for each
 klp_object
Message-ID: <Yy3JupD4iErp0daR@alley>
References: <20220902205208.3117798-1-song@kernel.org>
 <20220902205208.3117798-2-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220902205208.3117798-2-song@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2022-09-02 13:52:07, Song Liu wrote:
> Add per klp_object sysfs entry "patched". It makes it easier to debug
> typos in the module name.
> 
> Reviewed-by: Joe Lawrence <joe.lawrence@redhat.com>
> Signed-off-by: Song Liu <song@kernel.org>

Just a note. Signed-off-by of the author is always the first entry.
It is followed by Acked-by, Reviewed-by, Tested-by, ... in the order
in which they arrived.

I have fixed the ordering when pushing the patch.

> --- a/Documentation/ABI/testing/sysfs-kernel-livepatch
> +++ b/Documentation/ABI/testing/sysfs-kernel-livepatch
> @@ -55,6 +55,14 @@ Description:
>  		The object directory contains subdirectories for each function
>  		that is patched within the object.
>  
> +What:		/sys/kernel/livepatch/<patch>/<object>/patched
> +Date:		August 2022
> +KernelVersion:	6.0.0

Also I have updated the version to 6.1.0. It should be the version
produced by the upcoming merge window.

Best Regards,
Petr
