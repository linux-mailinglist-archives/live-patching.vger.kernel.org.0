Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4DEB6288E4
	for <lists+live-patching@lfdr.de>; Mon, 14 Nov 2022 20:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236432AbiKNTHr (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 14 Nov 2022 14:07:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbiKNTHr (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 14 Nov 2022 14:07:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F54160F9;
        Mon, 14 Nov 2022 11:07:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C753361377;
        Mon, 14 Nov 2022 19:07:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7627C433D6;
        Mon, 14 Nov 2022 19:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668452865;
        bh=l7A49gjr9j/uZ82ZG9hzVk62CqZLvcwywWGZev/QKic=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DKfzM7/rjpcyi8gIgsAQem4d1cpWYgcafF5af6FRh9jofVnTGykIjZHja/FpkIr3F
         9An2y1RKngLWeKF2P4DD9bAGSa1MdbMU15cQOX7p7AA4s9tEoi/RWhr6tN/9owIP+U
         oUG8Lnv6uq1TDwO3OlKLZuhy87+x6tcbfUIXmhT0yDvxUG0jZi74tVnOol7yDP4Gpw
         d/q2am5OKmOh2s8yelDoHoEw5R5jwZuiTqeJD2VQ5ZU3bKoLTXVBBdLQF0Hpo/Yq0F
         kUykU8aIQ3toDFzet760xoTSa5Wu9vQLAglXnWIWDu7ti+F+HPP/rKstqQ/JiP+ldq
         neX7L/oLNT9Cg==
Date:   Mon, 14 Nov 2022 11:07:42 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Martin Liska <mliska@suse.cz>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 40/46] x86/livepatch, lto: Disable live patching with gcc
 LTO
Message-ID: <20221114190742.qekt42gvsv2ia3ng@treble>
References: <20221114114344.18650-1-jirislaby@kernel.org>
 <20221114114344.18650-41-jirislaby@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221114114344.18650-41-jirislaby@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Nov 14, 2022 at 12:43:38PM +0100, Jiri Slaby (SUSE) wrote:
> From: Andi Kleen <andi@firstfloor.org>
> 
> It is not supported by gcc 12 so far, so it causes compiler "sorry"
> messages.

What specifically is not supported by GCC 12?  What are the "sorry"
messages?

> Other than the compiler support, there shouldn't be any barriers for
> live patching LTOed kernels, although it might be more difficult to
> create patches for larger functions.

This seems to conflict with the documentation.

> Cc: Josh Poimboeuf <jpoimboe@kernel.org>
> Cc: Jiri Kosina <jikos@kernel.org>
> Cc: Miroslav Benes <mbenes@suse.cz>
> Cc: Petr Mladek <pmladek@suse.com>
> Cc: Joe Lawrence <joe.lawrence@redhat.com>
> Cc: live-patching@vger.kernel.org
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> Signed-off-by: Martin Liska <mliska@suse.cz>
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> ---
>  kernel/livepatch/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/livepatch/Kconfig b/kernel/livepatch/Kconfig
> index 53d51ed619a3..22699adc39a6 100644
> --- a/kernel/livepatch/Kconfig
> +++ b/kernel/livepatch/Kconfig
> @@ -12,6 +12,7 @@ config LIVEPATCH
>  	depends on KALLSYMS_ALL
>  	depends on HAVE_LIVEPATCH
>  	depends on !TRIM_UNUSED_KSYMS
> +	depends on !LTO_GCC # not supported in gcc

The comment doesn't help.

-- 
Josh
