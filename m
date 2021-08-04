Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A50DC3E0833
	for <lists+live-patching@lfdr.de>; Wed,  4 Aug 2021 20:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237378AbhHDSsH (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 4 Aug 2021 14:48:07 -0400
Received: from mga03.intel.com ([134.134.136.65]:61823 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240691AbhHDSrf (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 4 Aug 2021 14:47:35 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10066"; a="214017524"
X-IronPort-AV: E=Sophos;i="5.84,295,1620716400"; 
   d="scan'208";a="214017524"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2021 11:47:20 -0700
X-IronPort-AV: E=Sophos;i="5.84,295,1620716400"; 
   d="scan'208";a="419538604"
Received: from ssyedfar-mobl1.amr.corp.intel.com (HELO ldmartin-desk2) ([10.212.201.224])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2021 11:47:20 -0700
Date:   Wed, 4 Aug 2021 11:47:20 -0700
From:   Lucas De Marchi <lucas.demarchi@intel.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     linux-modules@vger.kernel.org, live-patching@vger.kernel.org,
        fstests@vger.kernel.org, linux-block@vger.kernel.org, hare@suse.de,
        dgilbert@interlog.com, jeyu@kernel.org, osandov@fb.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libkmod-module: add support for a patient module removal
 option
Message-ID: <20210804184720.z27u5aymcl5hzqgh@ldmartin-desk2>
References: <20210803202417.462197-1-mcgrof@kernel.org>
 <YQrVY8Wxb026TDWN@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YQrVY8Wxb026TDWN@bombadil.infradead.org>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Aug 04, 2021 at 10:58:59AM -0700, Luis Chamberlain wrote:
>On Tue, Aug 03, 2021 at 01:24:17PM -0700, Luis Chamberlain wrote:
>> + diff --git a/libkmod/libkmod-module.c b/libkmod/libkmod-module.c
><-- snip -->
>> +		ERR(mod->ctx, "%s refcnt is %ld waiting for it to become 0\n", mod->name, refcnt);
>
>OK after running many tests with this I think we need to just expand
>this so that the error message only applies when -v is passed to
>modprobe, otherwise we get the print message every time, and using
>INFO() doesn't cut it, given the next priority level available to
>the library is LOG_INFO (6) and when modprobe -v is passed we set the
>log level to LOG_NOTICE (5), so we need a new NOTICE(). I'll send a v2
>with that included as a separate patch.

Or maybe move the sleep to modprobe instead of doing it in the
library?  The sleep(1) seems like an arbitrary number to be introduced
in the lib.

Since kernfs is pollable, maybe we could rather introduce an API to
return the pid in which the application has to wait for and then the
application can use whatever it wants to poll, including controlling a
timeout.

I'm saying this because sleep(1) may be all fine for modprobe, but for
other applications using libkmod it may not play well with their mainloops
(and they may want to control both granularity of the sleep and a max
timeout).

thanks
Lucas De Marchi

>
>  Luis
