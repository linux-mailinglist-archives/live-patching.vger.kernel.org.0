Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F15B6C2C84
	for <lists+live-patching@lfdr.de>; Tue, 21 Mar 2023 09:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbjCUIeY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 21 Mar 2023 04:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjCUId6 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 21 Mar 2023 04:33:58 -0400
Received: from mail.ptr1337.dev (mail.ptr1337.dev [202.61.224.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A34234391C;
        Tue, 21 Mar 2023 01:33:08 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id C9F5F2800C1;
        Tue, 21 Mar 2023 09:33:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cachyos.org; s=dkim;
        t=1679387581; h=from:subject:date:message-id:to:mime-version:content-type:
         content-transfer-encoding:content-language:in-reply-to:references;
        bh=ETMQewYqFOxyEeyfz++LRASMN6UldVLdJx3vLdRJ+U8=;
        b=p1bxi7UdLGQgXoohfOEhj5UeH0nPUxhEjR6JNUfRnQ91T3hS+ISjInI6ZN+ahMEhsMVjrs
        bbMhYeudtfLB5fThe7V3AyrTrYTSwgnTD6+yynQ9JAcM3dJ0ybmS5cEJkxRW5//vSUPCuA
        nxt4iH5WvfcYZ2NxX95ez2DakRMZ9tn8l1RGBjtZeD+bgT5zWQ+Ggl1UL8GESk+JLXEp0g
        BBrWrkY4aPDNtXlCEAU0hZGvLecHYNT18+b1ACO+GcgCaebOnpFoCrsSPmKAnwANUs10bI
        dELABGj5PoQUnjn3xrd5UJJXaiw6/gqz2dpUnL0ePPpHVneNc+TDs6c0OSAgbQ==
Message-ID: <c0217d44-b13b-7126-8291-b2e9ee8c4db2@cachyos.org>
Date:   Tue, 21 Mar 2023 09:33:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] module/decompress: Never use kunmap() for local
 un-mappings
To:     linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        live-patching@vger.kernel.org, bpf@vger.kernel.org,
        llvm@lists.linux.dev
References: <20230315125256.22772-1-fmdefrancesco@gmail.com>
Content-Language: pl-PL, en-US
From:   Piotr Gorski <piotrgorski@cachyos.org>
In-Reply-To: <20230315125256.22772-1-fmdefrancesco@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Reviewed-by: Piotr Gorski <piotrgorski@cachyos.org>

W dniu 15.03.2023 o 13:52, Fabio M. De Francesco pisze:
> Use kunmap_local() to unmap pages locally mapped with kmap_local_page().
>
> kunmap_local() must be called on the kernel virtual address returned by
> kmap_local_page(), differently from how we use kunmap() which instead
> expects the mapped page as its argument.
>
> In module_zstd_decompress() we currently map with kmap_local_page() and
> unmap with kunmap(). This breaks the code and so it should be fixed.
>
> Cc: Piotr Gorski <piotrgorski@cachyos.org>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Luis Chamberlain <mcgrof@kernel.org>
> Cc: Stephen Boyd <swboyd@chromium.org>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Fixes: 169a58ad824d ("module/decompress: Support zstd in-kernel decompression")
> Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
> ---
>   kernel/module/decompress.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/module/decompress.c b/kernel/module/decompress.c
> index bb79ac1a6d8f..7ddc87bee274 100644
> --- a/kernel/module/decompress.c
> +++ b/kernel/module/decompress.c
> @@ -267,7 +267,7 @@ static ssize_t module_zstd_decompress(struct load_info *info,
>   		zstd_dec.size = PAGE_SIZE;
>   
>   		ret = zstd_decompress_stream(dstream, &zstd_dec, &zstd_buf);
> -		kunmap(page);
> +		kunmap_local(zstd_dec.dst);
>   		retval = zstd_get_error_code(ret);
>   		if (retval)
>   			break;
