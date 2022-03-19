Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD6A54DEA9D
	for <lists+live-patching@lfdr.de>; Sat, 19 Mar 2022 21:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244113AbiCSU0y (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 19 Mar 2022 16:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239578AbiCSU0x (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 19 Mar 2022 16:26:53 -0400
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E6CEB7;
        Sat, 19 Mar 2022 13:25:31 -0700 (PDT)
Received: by mail-qt1-f181.google.com with SMTP id d15so8223844qty.8;
        Sat, 19 Mar 2022 13:25:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Xp+N5oR8cNMK62aRPk8kZIBvTheB6GVjqMQFtxgItNY=;
        b=g9hH9oO50mX/FtAQPE/VTLA3U/i0VISm7aw1xYEFmbt5ltiUvCOqa4fQEDhflOpJPv
         ynrYGh41CN5saD0FkfQH+SJdV01sASKUPK4twUtYNzhUxniG9DADs0QUVDOrQW5r2MXm
         k55G0zw27bsOElcZRUh474SJ2h6Clv4/f0ZAbXhtRGPhKlzt6YbXfSAnYyTlkt3s4YX1
         Z6Z6o6V6NbVncm2Mhzii78I6G5gDK5chy1L4ATZehuAc60eJdO3l/bl2/9AIbI9k/Jdf
         uPbqB+b0CRqaGKqRvEAMmxHuQL7cQzjkjGkNJFbfoURtdnkk1y03SyKE9Iy0/zRi4Et+
         wgtQ==
X-Gm-Message-State: AOAM530bYFeMd+xW84niJsyDl8x8wd2upseBcRcRWrAXGQyuhr4Ae2Vn
        kGDDrKUyggYP5/nxa+PfHIOdxWKA5vzyWw==
X-Google-Smtp-Source: ABdhPJy22V69G2sn5CzTCipKqSCrMoDq1IayC54TiCihJO7Kv2zFonrvTzWuha3ql3MkiigxvK9adQ==
X-Received: by 2002:a05:622a:1a1d:b0:2e1:be1f:a4e8 with SMTP id f29-20020a05622a1a1d00b002e1be1fa4e8mr11352194qtb.371.1647721530594;
        Sat, 19 Mar 2022 13:25:30 -0700 (PDT)
Received: from dev0025.ash9.facebook.com (fwdproxy-ash-023.fbsv.net. [2a03:2880:20ff:17::face:b00c])
        by smtp.gmail.com with ESMTPSA id d26-20020a05620a159a00b0067d4f5637d7sm5549434qkk.14.2022.03.19.13.25.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 13:25:30 -0700 (PDT)
Date:   Sat, 19 Mar 2022 13:25:26 -0700
From:   David Vernet <void@manifault.com>
To:     trix@redhat.com
Cc:     jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        pmladek@suse.com, joe.lawrence@redhat.com, nathan@kernel.org,
        ndesaulniers@google.com, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH] livepatch: Reorder to use before freeing a pointer
Message-ID: <20220319202526.hlkrfxdod5mmkvp4@dev0025.ash9.facebook.com>
References: <20220319165159.2170650-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220319165159.2170650-1-trix@redhat.com>
User-Agent: NeoMutt/20211029
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Sat, Mar 19, 2022 at 09:51:59AM -0700, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> Clang static analysis reports this issue
> livepatch-shadow-fix1.c:113:2: warning: Use of
>   memory after it is freed
>   pr_info("%s: dummy @ %p, prevented leak @ %p\n",
>   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> The pointer is freed in the previous statement.
> Reorder the pr_info to report before the free.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>  samples/livepatch/livepatch-shadow-fix1.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/samples/livepatch/livepatch-shadow-fix1.c b/samples/livepatch/livepatch-shadow-fix1.c
> index 918ce17b43fda..6701641bf12d4 100644
> --- a/samples/livepatch/livepatch-shadow-fix1.c
> +++ b/samples/livepatch/livepatch-shadow-fix1.c
> @@ -109,9 +109,9 @@ static void livepatch_fix1_dummy_leak_dtor(void *obj, void *shadow_data)
>  	void *d = obj;
>  	int **shadow_leak = shadow_data;
>  
> -	kfree(*shadow_leak);
>  	pr_info("%s: dummy @ %p, prevented leak @ %p\n",
>  			 __func__, d, *shadow_leak);
> +	kfree(*shadow_leak);
>  }
>  
>  static void livepatch_fix1_dummy_free(struct dummy *d)
> -- 
> 2.26.3
> 

The fix looks good, though it looks like there is also a similar
use-after-free in livepatch_fix2_dummy_leak_dtor() in
livepatch-shadow-fix2.c. Could you please also fix that as part of this
patch?

Thanks,
David
