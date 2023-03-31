Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9082B6D2498
	for <lists+live-patching@lfdr.de>; Fri, 31 Mar 2023 18:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232771AbjCaQEr (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 31 Mar 2023 12:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233055AbjCaQEq (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 31 Mar 2023 12:04:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21BA81EFE4
        for <live-patching@vger.kernel.org>; Fri, 31 Mar 2023 09:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680278637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rSNZ8/l+VZ86qtadx/3cTwXAVAmwqfzRU1WoIUzmJNE=;
        b=Q2PAlJE+eKkIxRQBE6rhZbBUkIeudelOUKXcKiTGMA6QUNO7SmcLEyB1qNKoL4ICVfpG6d
        IhcFhJD2eW5QWsu/JKaRMynqrSWWpUiJG68f4NuO//cHzsfFmsaepuE5n85V5Icrj/O45H
        wqfIoXNYsQadUQ65NlOnngpwI8jkW2Y=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-513-VNJM1qaCNDWftioYRe3iXg-1; Fri, 31 Mar 2023 12:03:55 -0400
X-MC-Unique: VNJM1qaCNDWftioYRe3iXg-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-545e529206eso164952377b3.9
        for <live-patching@vger.kernel.org>; Fri, 31 Mar 2023 09:03:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680278635;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rSNZ8/l+VZ86qtadx/3cTwXAVAmwqfzRU1WoIUzmJNE=;
        b=loTFZfIElEJXgdIWsSw+nt3wHpMlEH8goXG6HYXX+rq/uwaRBWM//Ezj+l8DeRWGzO
         13SI0ZthG5uc2tCi6tek2PVl2Dlncjv41egH3xHNUs+tABH4RuP9Y2n0U5T7xzzWTyDM
         E+EscY/cXshZWo2dXbMmJEmwBfhhG9bd4Xqrfu19G9WjEL/06neGvR/u+TEZkgsAuczc
         VHePJkxmcHUexw4JT9Mgi3Np1UZmY7Or+15221488TqmXqXqM6nZ/rhTFuxieU7s3q3K
         Wtjdav528niKrmUnjQ0yi3cyRMCSsNmO4uzFeRhlqRgc45+Ci/TYe9RsMXhbaMKZoRkK
         BWUQ==
X-Gm-Message-State: AAQBX9fV76q8/Gs0AzDcC1JEYq9d3BP9IiNnxwN2XKloRx9jB2nyUQ+Z
        t3lmY/+mdSmdGpqUg/SVEZEPUFdJb+bpL0V5y5Om5HAmEVyI7eXkib4eEjolNSSHlP66CEFrDLQ
        mFMVmU6c6zD2RT1BIjnZbJRDWgUYJbnAXngPV
X-Received: by 2002:a05:7500:3e83:b0:fe:c8a6:575 with SMTP id li3-20020a0575003e8300b000fec8a60575mr286788gab.18.1680278634915;
        Fri, 31 Mar 2023 09:03:54 -0700 (PDT)
X-Google-Smtp-Source: AKy350aYLH+nRBLs0BOSrhOyR0e8vNMPADpf6r8qKAygoUTF/7n8384rN6qordhqj3TeCWcFnm7i8Q==
X-Received: by 2002:a05:7500:3e83:b0:fe:c8a6:575 with SMTP id li3-20020a0575003e8300b000fec8a60575mr286763gab.18.1680278634565;
        Fri, 31 Mar 2023 09:03:54 -0700 (PDT)
Received: from [192.168.1.12] (pool-68-160-135-240.bstnma.fios.verizon.net. [68.160.135.240])
        by smtp.gmail.com with ESMTPSA id y25-20020a37f619000000b0074382b756c2sm760767qkj.14.2023.03.31.09.03.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Mar 2023 09:03:54 -0700 (PDT)
Message-ID: <f1351c5f-16aa-8407-753c-90049956123d@redhat.com>
Date:   Fri, 31 Mar 2023 12:03:52 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     Alexey Dobriyan <adobriyan@gmail.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Marcos Paulo de Souza <mpdesouza@suse.com>
References: <4ce29654-4e1e-4680-9c25-715823ff5e02@p183>
 <683593a8-79db-4f3b-bc78-7917284683e4@p183>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH v7 00/10] livepatch: klp-convert tool
In-Reply-To: <683593a8-79db-4f3b-bc78-7917284683e4@p183>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 3/30/23 13:04, Alexey Dobriyan wrote:
> This patchset somehow breaks the build of the simplest livepatch module:
> 
> 	make -f linux/linux-1/scripts/Makefile.modfinal
> 	make[1]: *** No rule to make target 'linux/module-klp/main.tmp.ko', needed by 'linux/module-klp/main.ko'.  Stop.
> 

Thanks for testing.

Presumably this is an out-of-tree livepatch module?  If so, that is
still on the TODO list.  If not, that is weird as the patchset itself
includes updates to samples/ and lib/ livepatches that build and load fine.

-- 
Joe

> $ cat Kbuild
> obj-m := main.o
> 
> $ cat main.c
> #include <linux/module.h>
> #include <linux/kernel.h>
> #include <linux/livepatch.h>
> #include <linux/seq_file.h>
> 
> static int livepatch_cmdline_proc_show(struct seq_file *m, void *data)
> {
> 	seq_puts(m, "REDACTED 001\n");
> 	return 0;
> }
> 
> static struct klp_func funcs[] = {
> 	{
> 		.old_name = "cmdline_proc_show",
> 		.new_func = livepatch_cmdline_proc_show,
> 	},
> 	{}
> };
> 
> static struct klp_object objs[] = {
> 	{
> 		.funcs = funcs,
> 	},
> 	{}
> };
> 
> static struct klp_patch g_patch = {
> 	.mod = THIS_MODULE,
> 	.objs = objs,
> };
> 
> static int livepatch_init(void)
> {
> 	return klp_enable_patch(&g_patch);
> }
> 
> static void livepatch_exit(void)
> {
> }
> module_init(livepatch_init);
> module_exit(livepatch_exit);
> MODULE_LICENSE("GPL");
> MODULE_INFO(livepatch, "Y");
> 

