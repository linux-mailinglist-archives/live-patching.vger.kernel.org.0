Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB8216D0C2B
	for <lists+live-patching@lfdr.de>; Thu, 30 Mar 2023 19:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbjC3REd (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 30 Mar 2023 13:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232116AbjC3REa (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 30 Mar 2023 13:04:30 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 930F25B8E;
        Thu, 30 Mar 2023 10:04:28 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id b20so79181301edd.1;
        Thu, 30 Mar 2023 10:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680195867;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Mpi+z+1m9c/5uRG/3aPiuMWiZMpS1q80gTEBOdR4q6Q=;
        b=c4bCgw/UXvmKQisPMFDGVyNibLfbmS8Rm10f/D59iAwdXyB15AW0jvMLMqKgbxhEwe
         Ok+jZtrcuftqFVLu3mv8RwD2j1MAcZfDydLrwd9SdX5yha/fKZReTDcoKZx9uKK+EBd2
         k/ikHUqrHhlqet5+4twIpUVCBVKzMcLL+0Ef/z1NsjzV0jay7d/jOqJmfirnkmy0c7Bs
         cJWqjRMc6CiNmFYtOaTma68JtQPjQSENu+ByRWeDSvbt54v0sKeN4SoIMBn9kMekm2Z6
         iRsF9/4BjT0f3yXETUScGBScMQc4sZlGP07JjWFujWIfNUJ2hsWCBCQRAsW8No5MfilE
         Afew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680195867;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mpi+z+1m9c/5uRG/3aPiuMWiZMpS1q80gTEBOdR4q6Q=;
        b=JpzdhPook4a1v6QViL6DcOfmuDQ+WbrTz383/0llmEBUxvcUd9+qulboBZ4Y9Pq3jO
         OJW0GIdG6E9pTLsc4EZqaINqdLFZGPBdxA1KHm8kvrZQT4m4P2uglWnfw7s144GUHtRs
         /aA0CdVu5tzzdzGW0xQjkyMNeaW8SI3qyUOSbguNzIvBFKHhpK1YjiV2rImVslHqPF0z
         0/BAefUKUm5i14/YmiQQcnplTXdTvLw5SySyiHPkwX9KrWAq5PlvLL8MTStoNhZOYbuI
         GiaMVhZwfDeWCT+Peg//0/SnX4GASx767zjxK2AuYzA1Ytb0uLwruf99Jp28I+viciTC
         aGzw==
X-Gm-Message-State: AAQBX9eCKOvnGBxRdkeFm123Uri3UQI4if7o0HgfwoPvEzs5qhkfh1yR
        DcvdOsBQngzzUvm6ew75hQ==
X-Google-Smtp-Source: AKy350akG/cT7TWge0CvXUlRJpUrm1KLABeK22t+bLyqtpqkDQqmyaiVshjVor5jfLx5q+oxPQppaQ==
X-Received: by 2002:aa7:db92:0:b0:4fd:2346:7225 with SMTP id u18-20020aa7db92000000b004fd23467225mr24541640edt.34.1680195866853;
        Thu, 30 Mar 2023 10:04:26 -0700 (PDT)
Received: from p183 ([46.53.250.0])
        by smtp.gmail.com with ESMTPSA id z23-20020a50cd17000000b005021c7f08absm146947edi.29.2023.03.30.10.04.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 10:04:26 -0700 (PDT)
Date:   Thu, 30 Mar 2023 20:04:24 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: Re: [PATCH v7 00/10] livepatch: klp-convert tool
Message-ID: <683593a8-79db-4f3b-bc78-7917284683e4@p183>
References: <4ce29654-4e1e-4680-9c25-715823ff5e02@p183>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4ce29654-4e1e-4680-9c25-715823ff5e02@p183>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

This patchset somehow breaks the build of the simplest livepatch module:

	make -f linux/linux-1/scripts/Makefile.modfinal
	make[1]: *** No rule to make target 'linux/module-klp/main.tmp.ko', needed by 'linux/module-klp/main.ko'.  Stop.

$ cat Kbuild
obj-m := main.o

$ cat main.c
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/livepatch.h>
#include <linux/seq_file.h>

static int livepatch_cmdline_proc_show(struct seq_file *m, void *data)
{
	seq_puts(m, "REDACTED 001\n");
	return 0;
}

static struct klp_func funcs[] = {
	{
		.old_name = "cmdline_proc_show",
		.new_func = livepatch_cmdline_proc_show,
	},
	{}
};

static struct klp_object objs[] = {
	{
		.funcs = funcs,
	},
	{}
};

static struct klp_patch g_patch = {
	.mod = THIS_MODULE,
	.objs = objs,
};

static int livepatch_init(void)
{
	return klp_enable_patch(&g_patch);
}

static void livepatch_exit(void)
{
}
module_init(livepatch_init);
module_exit(livepatch_exit);
MODULE_LICENSE("GPL");
MODULE_INFO(livepatch, "Y");
