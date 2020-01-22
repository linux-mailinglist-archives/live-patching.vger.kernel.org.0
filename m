Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA067145BC1
	for <lists+live-patching@lfdr.de>; Wed, 22 Jan 2020 19:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728853AbgAVSvx (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Jan 2020 13:51:53 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35037 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725884AbgAVSvx (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Jan 2020 13:51:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579719112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AacXIVvW/L9Wi/tQd6CQ3WlW5xZVTV3hdmJ5WDrZQuI=;
        b=AjQbhojwJ/aVLYHgrlT7cR2+EPfBiEtpWyO3EpdIrY2yEso12Qe0s5Stvq+m6E4ffmGB1N
        o6P8r/hCEb2H/PN988wbG8KWm/OaYQvSWJVXNMwX6jRDodmGsUkEavc6VUPeKNuml24hVS
        vemaViBhYmEJEIGqAHfdhIB2DOfLrTI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-73-xp7zKNaSOzWdFXBAhugIeg-1; Wed, 22 Jan 2020 13:51:50 -0500
X-MC-Unique: xp7zKNaSOzWdFXBAhugIeg-1
Received: by mail-wr1-f69.google.com with SMTP id d8so390428wrq.12
        for <live-patching@vger.kernel.org>; Wed, 22 Jan 2020 10:51:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AacXIVvW/L9Wi/tQd6CQ3WlW5xZVTV3hdmJ5WDrZQuI=;
        b=QIhtjHx4LVhFGCkaRjrspNqKFMKIXlZtWVP8ASRS0KhkeI7LlCoZi1IW9S9uq4n968
         N9zipkKpKTZJex7CjOIL/VTAmiLibdXPN/05WX3gFHYUVpOlk60dgx5c4YAuyukIu63q
         jjOABhXy7sXjIFByKkuVzO30i6BdFdsyAh2lSQFdnv9XgkbuheqkH/TtiBDK8gMjyejE
         E5mhPtCxKh58DwckjyrPXCVedUQcGYOw969letZuqHTQ2eXTE7AqUsLnI0p6Er0IPJ2H
         20p49rejmexVivwjUWiRm0WOwEyp1ACH0S0eniQdpF7fDlNK5k0lRA+ELgcKZLkXItIn
         lpSA==
X-Gm-Message-State: APjAAAU5qjqKRx+gBm5etn/GijXA5pqvE6jOw9wLwH8HsXxfDNGaNnHN
        qM580qEQTbaYZqu/CXoFQHtthBzdGLGoQcOv8Wq43Xkz3Lw2unCEulWhAOpAtbqqQNX54tJTdN1
        hMUFjeMQk34KcixP9mWRW+OnM9A==
X-Received: by 2002:a7b:cf0d:: with SMTP id l13mr4555109wmg.13.1579719109384;
        Wed, 22 Jan 2020 10:51:49 -0800 (PST)
X-Google-Smtp-Source: APXvYqwjoe52IEp8wH9WLT03b8oTlH5pHHcleUFCdfM3BUg8u4w8DvvniP1058w8iBiqweitzvHTNg==
X-Received: by 2002:a7b:cf0d:: with SMTP id l13mr4555090wmg.13.1579719109177;
        Wed, 22 Jan 2020 10:51:49 -0800 (PST)
Received: from [192.168.1.81] (host81-140-166-164.range81-140.btcentralplus.com. [81.140.166.164])
        by smtp.gmail.com with ESMTPSA id v17sm58395781wrt.91.2020.01.22.10.51.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2020 10:51:48 -0800 (PST)
Subject: Re: [POC 09/23] livepatch: Handle race when livepatches are reloaded
 during a module load
To:     Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200117150323.21801-1-pmladek@suse.com>
 <20200117150323.21801-10-pmladek@suse.com>
From:   Julien Thierry <jthierry@redhat.com>
Message-ID: <9f79bff4-42b2-ad1e-6ca6-a3464ab56ef4@redhat.com>
Date:   Wed, 22 Jan 2020 18:51:47 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200117150323.21801-10-pmladek@suse.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Petr,

On 1/17/20 3:03 PM, Petr Mladek wrote:
> klp_module_coming() might fail to load a livepatch module when
> the related livepatch gets reloaded in the meantime.
> 
> Detect this situation by adding a timestamp into struct klp_patch.
> local_clock is enough because klp_mutex must be released and taken
> several times during this scenario.
> 
> Signed-off-by: Petr Mladek <pmladek@suse.com>
> ---
>   include/linux/livepatch.h | 2 ++
>   kernel/livepatch/core.c   | 9 +++++----
>   2 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> index a4567c17a9f2..feb33f023f9f 100644
> --- a/include/linux/livepatch.h
> +++ b/include/linux/livepatch.h
> @@ -155,6 +155,7 @@ struct klp_state {
>    * @obj_list:	dynamic list of the object entries
>    * @enabled:	the patch is enabled (but operation may be incomplete)
>    * @forced:	was involved in a forced transition
> + * ts:		timestamp when the livepatch has been loaded

Nit: Missing '@'.

>    * @free_work:	patch cleanup from workqueue-context
>    * @finish:	for waiting till it is safe to remove the patch module
>    */
> @@ -171,6 +172,7 @@ struct klp_patch {
>   	struct list_head obj_list;
>   	bool enabled;
>   	bool forced;
> +	u64 ts;
>   	struct work_struct free_work;
>   	struct completion finish;
>   };
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index 34e3ee2be7ef..8e693c58b736 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -20,6 +20,7 @@
>   #include <linux/moduleloader.h>
>   #include <linux/completion.h>
>   #include <linux/memory.h>
> +#include <linux/sched/clock.h>
>   #include <asm/cacheflush.h>
>   #include "core.h"
>   #include "patch.h"
> @@ -854,6 +855,7 @@ static int klp_init_patch_early(struct klp_patch *patch)
>   	kobject_init(&patch->kobj, &klp_ktype_patch);
>   	patch->enabled = false;
>   	patch->forced = false;
> +	patch->ts = local_clock();
>   	INIT_WORK(&patch->free_work, klp_free_patch_work_fn);
>   	init_completion(&patch->finish);
>   
> @@ -1324,6 +1326,7 @@ int klp_module_coming(struct module *mod)
>   {
>   	char patch_name[MODULE_NAME_LEN];
>   	struct klp_patch *patch;
> +	u64 patch_ts;
>   	int ret = 0;
>   
>   	if (WARN_ON(mod->state != MODULE_STATE_COMING))
> @@ -1339,6 +1342,7 @@ int klp_module_coming(struct module *mod)
>   			continue;
>   
>   		strncpy(patch_name, patch->obj->patch_name, sizeof(patch_name));
> +		patch_ts = patch->ts;
>   		mutex_unlock(&klp_mutex);
>   
>   		ret = klp_try_load_object(patch_name, mod->name);
> @@ -1346,14 +1350,11 @@ int klp_module_coming(struct module *mod)
>   		 * The load might have failed because the patch has
>   		 * been removed in the meantime. In this case, the
>   		 * error might be ignored.
> -		 *
> -		 * FIXME: It is not fully proof. The patch might have be
> -		 * unloaded and loaded again in the mean time.
>   		 */
>   		mutex_lock(&klp_mutex);
>   		if (ret) {
>   			patch = klp_find_patch(patch_name);
> -			if (patch)
> +			if (patch && patch->ts == patch_ts)
>   				goto err;

If the timestamps differ, we have found the klp_patch, feels a bit of a 
waste to go through the list again without trying to load it right away.

Admittedly this is to solve a race condition which should not even 
happen very often...

>   			ret = 0;
>   		}
> 

Cheers,

-- 
Julien Thierry

