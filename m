Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 553766A863F
	for <lists+live-patching@lfdr.de>; Thu,  2 Mar 2023 17:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbjCBQXa (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 2 Mar 2023 11:23:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbjCBQX3 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 2 Mar 2023 11:23:29 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB2D17CC0;
        Thu,  2 Mar 2023 08:23:26 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 740EE21FD2;
        Thu,  2 Mar 2023 16:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1677774205; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TWP+794MyCIWP+G+s4FT51Bi2rDWxsLNhSxzg1q2+dk=;
        b=AQXyAurahCpZQ/er1h3ERHbroqld5zzRgHyJzW3DsH7dcDqZctGiROLW6FOg95me3zhlVb
        S6XAUPxmZyTVUgjyw6NGXwJaxPI9/Ls/OuWFqq0BzjANLaHPcVjsAaE6uKr0qAm3Nxyxht
        BQNpi8MkN1fvH4koRYf1y2AN6N7u5C0=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 73AEB2C141;
        Thu,  2 Mar 2023 16:23:24 +0000 (UTC)
Date:   Thu, 2 Mar 2023 17:23:18 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     "Tomohiro Misono (Fujitsu)" <misono.tomohiro@fujitsu.com>
Cc:     "'madvenka@linux.microsoft.com'" <madvenka@linux.microsoft.com>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "chenzhongjin@huawei.com" <chenzhongjin@huawei.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "Keiya Nobuta (Fujitsu)" <nobuta.keiya@fujitsu.com>,
        "sjitindarsingh@gmail.com" <sjitindarsingh@gmail.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "jamorris@linux.microsoft.com" <jamorris@linux.microsoft.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v3 00/22] arm64: livepatch: Use ORC for dynamic frame
 pointer validation
Message-ID: <ZADNdp5U+lP10Oqo@alley>
References: <0337266cf19f4c98388e3f6d09f590d9de258dc7>
 <20230202074036.507249-1-madvenka@linux.microsoft.com>
 <TYCPR01MB69938E7E2E14697FCF166155E5AD9@TYCPR01MB6993.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYCPR01MB69938E7E2E14697FCF166155E5AD9@TYCPR01MB6993.jpnprd01.prod.outlook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2023-03-01 03:12:08, Tomohiro Misono (Fujitsu) wrote:
> <snip>
> > Testing
> > =======
> > 
> > - I have run all of the livepatch selftests successfully. I have written a
> >   couple of extra selftests myself which I will be posting separately
> Hi,
> 
> What test configuration/environment you are using for test?
> When I tried kselftest with fedora based config on VM, I got errors
> because livepatch transition won't finish until signal is sent
> (i.e. it takes 15s for every transition).
> 
> [excerpt from test result]
>   ```
>   $ sudo ./test-livepatch.sh
>   TEST: basic function patching ... not ok
>   
>   --- expected
>   +++ result
>   @@ -2,11 +2,13 @@
>    livepatch: enabling patch 'test_klp_livepatch'
>    livepatch: 'test_klp_livepatch': initializing patching transition
>    livepatch: 'test_klp_livepatch': starting patching transition
>   +livepatch: signaling remaining tasks
>    livepatch: 'test_klp_livepatch': completing patching transition
>   ```

It might be interesting to see what process is blocking the
transition. The transition state is visible in
/proc/<pid>/patch_state.

The transition is blocked when a process is in KLP_UNPATCHED state.
It is defined in include/linux/livepatch.h:

#define KLP_UNPATCHED	 0

Well, the timing against the transition is important. The following
might help to see the blocking processes:

$> modprobe livepatch-sample ; \
   sleep 1; \
   for proc_path in \
       `grep "\-1"  /proc/*/patch_state | cut -d '/'  -f-3` ; \
   do \
       cat $proc_path/comm ; \
       cat $proc_path/stack ; \
       echo ===  ; \
   done

After this the livepatch has to be manualy disabled and removed

$> echo 0 >/sys/kernel/livepatch/livepatch_sample/enabled
$> rmmod livepatch_sample

Best Regards,
Petr
