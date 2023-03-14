Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1726B9E0D
	for <lists+live-patching@lfdr.de>; Tue, 14 Mar 2023 19:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjCNSRV (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 14 Mar 2023 14:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjCNSRU (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 14 Mar 2023 14:17:20 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60776BC37;
        Tue, 14 Mar 2023 11:17:18 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 0C0B21F8BA;
        Tue, 14 Mar 2023 18:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678817837; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YLIuIjePw0AXA6BmEraD20IliZzbWVdaCt1MG07LrQ4=;
        b=e0fhVj3JMLZkbQKEOI9rS9zzdbQcoojjtz1n0NOR1VwvHDpdkcScPrhCdT8yVdZNXFXtCc
        WVUJMd2vyg2471DAfdHmonAVoNTuSgagIJQq86HZNcQh2PJM6KnfLexvPg/5kM3yTqyRYX
        sFtcZ/XKOHwNGT8CP4ZCF9aHC0FfaOE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678817837;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YLIuIjePw0AXA6BmEraD20IliZzbWVdaCt1MG07LrQ4=;
        b=17b05HfqhnT7UcZ6YXL7+JK0QxBOa+go5bQIUNHuvECDCEjr6Bp7X7ZhX8vT76w3iGwEdB
        6gWRPB9+T5YB7CAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5F9D413A26;
        Tue, 14 Mar 2023 18:17:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id dDU5BCy6EGQOIQAAMHmgww
        (envelope-from <mpdesouza@suse.com>); Tue, 14 Mar 2023 18:17:16 +0000
Date:   Tue, 14 Mar 2023 15:17:13 -0300
From:   Marcos Paulo de Souza <mpdesouza@suse.de>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: Re: [PATCH v7 04/10] livepatch: Add sample livepatch module
Message-ID: <20230314181713.tgpc7t7yia5nlhil@daedalus>
References: <20230306140824.3858543-1-joe.lawrence@redhat.com>
 <20230306140824.3858543-5-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306140824.3858543-5-joe.lawrence@redhat.com>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Mar 06, 2023 at 09:08:18AM -0500, Joe Lawrence wrote:
> Add a new livepatch sample in samples/livepatch/ to make use of symbols
> that must be post-processed to enable load-time relocation resolution.
> As the new sample is to be used as an example, it is annotated with
> KLP_MODULE_RELOC and with KLP_SYMPOS macros.
> 
> The livepatch sample updates the function cmdline_proc_show to print the
> string referenced by the symbol saved_command_line appended by the
> string "livepatch=1".
> 
> Update livepatch-sample.c to remove livepatch MODULE_INFO statement.

LGTM:

Reviewed-by: Marcos Paulo de Souza <mpdesouza@suse.com>

> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Signed-off-by: Joao Moreira <jmoreira@suse.de>
> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> ---
>  samples/livepatch/Makefile                    |  1 +
>  .../livepatch/livepatch-annotated-sample.c    | 93 +++++++++++++++++++
>  2 files changed, 94 insertions(+)
>  create mode 100644 samples/livepatch/livepatch-annotated-sample.c
> 
> diff --git a/samples/livepatch/Makefile b/samples/livepatch/Makefile
> index 9f853eeb6140..f2b41f4d6c16 100644
> --- a/samples/livepatch/Makefile
> +++ b/samples/livepatch/Makefile
> @@ -6,3 +6,4 @@ obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-shadow-fix2.o
>  obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-callbacks-demo.o
>  obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-callbacks-mod.o
>  obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-callbacks-busymod.o
> +obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-annotated-sample.o
> diff --git a/samples/livepatch/livepatch-annotated-sample.c b/samples/livepatch/livepatch-annotated-sample.c
> new file mode 100644
> index 000000000000..4fe0e16423c7
> --- /dev/null
> +++ b/samples/livepatch/livepatch-annotated-sample.c
> @@ -0,0 +1,93 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Copyright (C) 2014 Seth Jennings <sjenning@redhat.com>
> + */
> +
> +/*
> + * livepatch-annotated-sample.c - Kernel Live Patching Sample Module
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/livepatch.h>
> +
> +/*
> + * This (dumb) live patch overrides the function that prints the
> + * kernel boot cmdline when /proc/cmdline is read.
> + *
> + * This livepatch uses the symbol saved_command_line whose relocation
> + * must be resolved during load time. To enable that, this module
> + * must be post-processed by a tool called klp-convert, which embeds
> + * information to be used by the loader to solve the relocation.
> + *
> + * The module is annotated with KLP_MODULE_RELOC/KLP_SYMPOS macros.
> + * These annotations are used by klp-convert to infer that the symbol
> + * saved_command_line is in the object vmlinux.
> + *
> + * As saved_command_line has no other homonimous symbol across
> + * kernel objects, this annotation is not a requirement, and can be
> + * suppressed with no harm to klp-convert. Yet, it is kept here as an
> + * example on how to annotate livepatch modules that contain symbols
> + * whose names are used in more than one kernel object.
> + *
> + * Example:
> + *
> + * $ cat /proc/cmdline
> + * <your cmdline>
> + *
> + * $ insmod livepatch-sample.ko
> + * $ cat /proc/cmdline
> + * <your cmdline> livepatch=1
> + *
> + * $ echo 0 > /sys/kernel/livepatch/livepatch_sample/enabled
> + * $ cat /proc/cmdline
> + * <your cmdline>
> + */
> +
> +extern char *saved_command_line;
> +
> +#include <linux/seq_file.h>
> +static int livepatch_cmdline_proc_show(struct seq_file *m, void *v)
> +{
> +	seq_printf(m, "%s livepatch=1\n", saved_command_line);
> +	return 0;
> +}
> +
> +KLP_MODULE_RELOC(vmlinux) vmlinux_relocs[] = {
> +	KLP_SYMPOS(saved_command_line, 0)
> +};
> +
> +static struct klp_func funcs[] = {
> +	{
> +		.old_name = "cmdline_proc_show",
> +		.new_func = livepatch_cmdline_proc_show,
> +	}, { }
> +};
> +
> +static struct klp_object objs[] = {
> +	{
> +		/* name being NULL means vmlinux */
> +		.funcs = funcs,
> +	}, { }
> +};
> +
> +static struct klp_patch patch = {
> +	.mod = THIS_MODULE,
> +	.objs = objs,
> +};
> +
> +static int livepatch_init(void)
> +{
> +	return klp_enable_patch(&patch);
> +}
> +
> +static void livepatch_exit(void)
> +{
> +}
> +
> +module_init(livepatch_init);
> +module_exit(livepatch_exit);
> +MODULE_LICENSE("GPL");
> +MODULE_INFO(livepatch, "Y");
> -- 
> 2.39.2
> 
