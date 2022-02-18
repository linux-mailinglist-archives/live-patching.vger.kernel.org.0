Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 603A54BB408
	for <lists+live-patching@lfdr.de>; Fri, 18 Feb 2022 09:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbiBRIVG (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 18 Feb 2022 03:21:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbiBRIVD (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 18 Feb 2022 03:21:03 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB82E25B2F7;
        Fri, 18 Feb 2022 00:20:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645172446; x=1676708446;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5ejHrB5B466U6W+fI4GxsWg/8qpDAbd2bstCAFg1MpY=;
  b=DesFvz0AAfxYpo6A+wazO9ViMVpCMtIHCj1JdwxvlrAtsy0eUxAKnK4F
   IBtT6QHvmG26x/5RwHAAtGkHRDIIMcRPX4YJUB7VVlaOXLv9KH2LDVq3n
   +qrQ5H5+jCSjmcdIwT1zNojTZeLZFzlHLq47Gt/Zf1o0pMzClZyoTSL/b
   ++xBBTjlKepEMH+63dwB1jnZuVv8KvaIYERQzJCWXxbViMr0z+pccBf18
   zzBZRV8lNF4oSQwVGj0dYeNHDS6fxN298X9JX4RhA48Uguf2CpfOCGkmY
   o/YCKamHNNro54raPMJIgv+SR29OqXcn5IR63E2+JAoZW+wEIq/poHM39
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10261"; a="275675307"
X-IronPort-AV: E=Sophos;i="5.88,378,1635231600"; 
   d="scan'208";a="275675307"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2022 00:20:46 -0800
X-IronPort-AV: E=Sophos;i="5.88,378,1635231600"; 
   d="scan'208";a="505115448"
Received: from svaddara-mobl.amr.corp.intel.com (HELO ldmartin-desk2) ([10.212.147.37])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2022 00:20:45 -0800
Date:   Fri, 18 Feb 2022 00:20:46 -0800
From:   Lucas De Marchi <lucas.demarchi@intel.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Lucas De Marchi <lucas.de.marchi@gmail.com>,
        linux-modules <linux-modules@vger.kernel.org>,
        live-patching@vger.kernel.org, fstests@vger.kernel.org,
        linux-block@vger.kernel.org, hare@suse.de, dgilbert@interlog.com,
        Jessica Yu <jeyu@kernel.org>, osandov@fb.com,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] kmod: add patient module removal support
Message-ID: <20220218082046.c33zz64owau3oiln@ldmartin-desk2>
X-Patchwork-Hint: comment
References: <20210810051602.3067384-1-mcgrof@kernel.org>
 <YUIwKUXc7YbVAqut@bombadil.infradead.org>
 <CAKi4VAKbN31hqfg5EHZO=T_Hdkv3uhzarFLuEZO4b5Zm+TF77Q@mail.gmail.com>
 <Yg4Djc+vqRbMFRto@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Yg4Djc+vqRbMFRto@bombadil.infradead.org>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Feb 17, 2022 at 12:13:01AM -0800, Luis Chamberlain wrote:
>On Mon, Sep 20, 2021 at 10:51:46PM -0700, Lucas De Marchi wrote:
>> On Wed, Sep 15, 2021 at 10:41 AM Luis Chamberlain <mcgrof@kernel.org> wrote:
>> >
>> > *Friendly poke*
>>
>> Sorry for the delay. Let me take a look in detail tomorrow.
>
>*Friendly poke*

oh, I dropped the ball here, sorry. Then I got busy with i915 and other
projects. Let me take a look again at your implementation and respin it

Lucas De Marchi
>
>  Luis
