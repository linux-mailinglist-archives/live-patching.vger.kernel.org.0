Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC73C584040
	for <lists+live-patching@lfdr.de>; Thu, 28 Jul 2022 15:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiG1No5 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 28 Jul 2022 09:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbiG1No5 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 28 Jul 2022 09:44:57 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D57661B36
        for <live-patching@vger.kernel.org>; Thu, 28 Jul 2022 06:44:56 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 056862079C;
        Thu, 28 Jul 2022 13:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1659015895; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/s1adq1VNuPbznikMaafoq06m/LCkdLQ/OALtST8BoQ=;
        b=XgYQTtqdUJaABRlstR/P2etHSuRJvNuF1komNvsvBhXLby3HR2M67a1UwLSd1NLdbceG4j
        FwHMw0NTAARhaTD+f2UTy/MoITGlG+3eIWKfRUNmxlbL9CfEbGMQOB6tlDVOxtWx3GO+VD
        2mpZ/sRJMH6nTmR5Qq/7y5uvWK8Hivw=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id D5AB92C141;
        Thu, 28 Jul 2022 13:44:54 +0000 (UTC)
Date:   Thu, 28 Jul 2022 15:44:52 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Song Liu <song@kernel.org>
Cc:     live-patching@vger.kernel.org, jpoimboe@kernel.org,
        jikos@kernel.org, mbenes@suse.cz, joe.lawrence@redhat.com
Subject: Re: [PATCH RFC] livepatch: add sysfs entry "patched" for each
 klp_object
Message-ID: <YuKS1Bg8hlvEUSY2@alley>
References: <20220725220231.3273447-1-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220725220231.3273447-1-song@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon 2022-07-25 15:02:31, Song Liu wrote:
> I was debugging an issue that a livepatch appears to be attached, but
> actually not. It turns out that there is a mismatch in module name
> (abc-xyz vs. abc_xyz), klp_find_object_module failed to find the module.

This might be a quite common mistake. IMHO, the module name stored in
the module metadata always uses underscore '_' instead of dash '-'.

If I get it correctly, it is done by the following command in
scripts/Makefile.lib:

--- cut ---
# These flags are needed for modversions and compiling, so we define them here
# $(modname_flags) defines KBUILD_MODNAME as the name of the module it will
# end up in (or would, if it gets compiled in)
name-fix-token = $(subst $(comma),_,$(subst -,_,$1))
--- cut ---

It might be worth to check it in klp_init_object() and warn when the
module name contains the dash '-'. It would allow to catch this
mistake during testing.


> Add per klp_object sysfs entry "patched" to make it easier to debug such
> issues.

IMHO, this makes sense anyway. It would be useful for debugging any
typo in the module name.

Just please, use imperative style for the commit message. For example:

Add per klp_object sysfs entry "patched". It makes it easier to debug
typos in the module name.


> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -364,6 +364,7 @@ static void klp_clear_object_relocations(struct module *pmod,
>   * /sys/kernel/livepatch/<patch>/transition
>   * /sys/kernel/livepatch/<patch>/force
>   * /sys/kernel/livepatch/<patch>/<object>
> + * /sys/kernel/livepatch/<patch>/<object>/patched
>   * /sys/kernel/livepatch/<patch>/<object>/<function,sympos>
>   */
>  static int __klp_disable_patch(struct klp_patch *patch);

Please, document it also in
Documentation/ABI/testing/sysfs-kernel-livepatch

> @@ -470,6 +471,22 @@ static struct attribute *klp_patch_attrs[] = {
>  };
>  ATTRIBUTE_GROUPS(klp_patch);
>  
> +static ssize_t patched_show(struct kobject *kobj,
> +			    struct kobj_attribute *attr, char *buf)
> +{
> +	struct klp_object *obj;
> +
> +	obj = container_of(kobj, struct klp_object, kobj);
> +	return snprintf(buf, PAGE_SIZE, "%d\n", obj->patched);

Please, use:

	return sysfs_emit(buf, "%d\n", obj->patched);

It is a rather new API that should be used to avoid various mistakes.

snprintf() is a common mistake. It returns the length needed to print
the entire string. sysfs_emit() uses scnprintf() that returns
the really used buffer size and never goes beyond the buffer size.

It would be great to use sysfs_emit() everywhere in the livepatch
code. But it needs to be done separately.

> +}
> +
> +static struct kobj_attribute patched_kobj_attr = __ATTR_RO(patched);
> +static struct attribute *klp_object_attrs[] = {
> +	&patched_kobj_attr.attr,
> +	NULL,
> +};
> +ATTRIBUTE_GROUPS(klp_object);
> +
>  static void klp_free_object_dynamic(struct klp_object *obj)
>  {
>  	kfree(obj->name);

Finally, please add a selftest for the new "patched" interface.

Best Regards,
Petr
